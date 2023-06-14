# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time, null: false
      t.integer :prep_time, null: false
      t.float :ratings, default: 0.0
      t.references :author, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
