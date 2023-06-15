# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  cook_time   :integer          not null
#  prep_time   :integer          not null
#  ratings     :float            default(0.0)
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint
#  category_id :bigint
#
# Indexes
#
#  index_recipes_on_author_id    (author_id)
#  index_recipes_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#  fk_rails_...  (category_id => categories.id)
#
FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    cook_time { 1 }
    prep_time { 1 }
    author { nil }
    category { nil }

    trait :with_ingredients do
      transient do
        ingredient_names { [] }
      end

      after(:create) do |recipe, evaluator|
        evaluator.ingredient_names.each do |ingredient_name|
          create(:ingredient, name: ingredient_name, recipe_id: recipe.id)
        end
      end
    end

    trait :with_author do
      author
    end

    trait :with_category do
      category
    end
  end
end
