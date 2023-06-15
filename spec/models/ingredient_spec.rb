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

    context 'when there is another record' do
      subject { create(:ingredient, recipe: build(:recipe)) }

      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:recipe_id) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:recipe) }
  end
end
