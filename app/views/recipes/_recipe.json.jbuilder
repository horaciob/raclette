# frozen_string_literal: true

json.extract! recipe, :id, :title, :cook_time, :prep_time, :rating, :author_id, :category_id, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
