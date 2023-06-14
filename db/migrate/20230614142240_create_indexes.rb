# frozen_string_literal: true

class CreateIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :categories, :name, unique: true
    add_index :authors, :name, unique: true
    add_index :ingredients, :name
  end
end
