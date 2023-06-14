# frozen_string_literal: true

# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_ingredients_on_name       (name)
#  index_ingredients_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
require 'rails_helper'

RSpec.describe Ingredient do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:recipe) }
  end
end
