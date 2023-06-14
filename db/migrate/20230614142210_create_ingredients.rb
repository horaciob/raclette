# frozen_string_literal: true

class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
