# frozen_string_literal: true

class AddIngredientsTypeAndAmount < ActiveRecord::Migration[7.0]
  def change
    change_table :ingredients, bulk: true do |t|
      t.string :amount
      t.string :amount_type
      t.string :source
    end
  end
end
