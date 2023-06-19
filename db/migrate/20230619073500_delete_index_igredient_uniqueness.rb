# frozen_string_literal: true

class DeleteIndexIgredientUniqueness < ActiveRecord::Migration[7.0]
  def change
    remove_index :ingredients, %i[name recipe_id], unique: true
  end
end
