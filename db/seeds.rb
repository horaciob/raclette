# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
DIR_SAMPLES = 'examples'
FILE_NAME = 'recipes-en.json'
logger = Logger.new('log/seed_errors.log')
# Im going to assume that i can host this on memory to speedup seeds
# I wanted to avoid to create many select to check if author or categories exists
#
def manage_uniq_creation_for(klass:, dictionary:, name:, mutex:, image: nil)
  return if name.blank? || dictionary[name]

  mutex.synchronize do
    params = { name: }
    params[:image] = image if image

    record = klass.create!(params)
    dictionary[name] = record.id
  end
end

def create_recipe(recipe:, author_id:, category_id:, ingredients:)
  recipe_params = recipe.slice('title', 'cook_time', 'prep_time', 'ratings')
  recipe_params['author_id'] = author_id
  recipe_params['category_id'] = category_id
  recipe_params['ingredients_attributes'] = ingredients

  Recipe.create(recipe_params)
end

def build_ingredients_params(ingredients)
  type_of_amounts = %w[tablespoon tablespoons pound cups cup pinch large medium small clove can cans bottle bottles packages
                       package slices slice ripe ripes Granny tablespoons tablespoon teaspoon teaspoons ounces ounce]

  regex = %r{^(?<amount>[\d\u00BC-\u00BE\u2150-\u215E]+)?(?:\s+(?<amount_type>(?:(?:#{Regexp.union(type_of_amounts)})s?))?\s)?+(?<ingredient>.*)$}

  ingredients.map do |line|
    line_with_no_parenthesis = line.gsub(/\([^)]*\)/, '')
    result = line_with_no_parenthesis.match(regex)

    { amount: result[:amount], amount_type: result[:amount_type],
      name: result[:ingredient].strip, source: line }
  end
end

authors = {}
categories = {}

thread_pool = Concurrent::ThreadPoolExecutor.new(max_threads: ActiveRecord::Base.connection_pool.size - 2)
thread_pool = Concurrent::ThreadPoolExecutor.new(max_threads: 3)

mutex_categories = Mutex.new
mutex_authors = Mutex.new

raw_datum = File.read("#{File.dirname(__FILE__)}/#{DIR_SAMPLES}/#{FILE_NAME}")
parsed_data = Oj.load(raw_datum)
count = 0

parsed_data.each do |recipe|
  thread_pool.post do
    count += 1
    Rails.logger.debug { "checkpoint #{count}" } if (count % 1000).zero?
    manage_uniq_creation_for(klass: Author, dictionary: authors, name: recipe['author'],
                             image: recipe['image'],
                             mutex: mutex_authors)
    manage_uniq_creation_for(klass: Category, dictionary: categories,
                             name: recipe['category'], mutex: mutex_categories)

    params_ingredients = build_ingredients_params(recipe['ingredients'])

    record = create_recipe(recipe:, author_id: authors[recipe['author']],
                           category_id: categories[recipe['category']],
                           ingredients: params_ingredients)
    logger.error("could not save #{recipe}       #{record.errors.inspect}") unless record.persisted?
  end
end

thread_pool.shutdown
thread_pool.wait_for_termination

Rails.logger.debug { "Recipies on DB=#{Recipe.count} recipies on json #{parsed_data.count}" }
