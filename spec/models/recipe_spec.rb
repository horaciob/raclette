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
require 'rails_helper'

RSpec.describe Recipe do
  describe 'validations' do
    subject { build(:recipe, :with_author, :with_category) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:cook_time) }
    it { is_expected.to validate_presence_of(:prep_time) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:author).optional }
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to have_many(:ingredients).dependent(:destroy) }
  end

  describe 'default values' do
    let(:recipe) { build(:recipe, :with_author, :with_category) }

    it 'ratings is default to 0.0' do
      recipe.save
      expect(recipe.reload.ratings).to eq 0.0
    end
  end

  describe 'when filter by ingredients' do
    subject { described_class.by_ingredients(ingredients) }

    let_it_be(:recipe1) { create(:recipe, :with_ingredients, ingredient_names: %w[onion garlic]) }
    let_it_be(:recipe2) { create(:recipe, :with_ingredients, ingredient_names: %w[onion garlic tomato]) }
    let_it_be(:recipe3) { create(:recipe, :with_ingredients, ingredient_names: %w[onion garlic tomato oil]) }

    describe '.by_ingredients' do
      context 'when it doesnt have enought ingredients' do
        let(:ingredients) { ['onion'] }

        it 'returns empty array' do
          expect(subject).to eq []
        end
      end

      context 'when it has exactly those ingredients' do
        let(:ingredients) { %w[onion garlic tomato] }

        it 'returns an array that include exact matching' do
          expect(subject).to include(recipe2)
        end

        it 'returns an array that include non exacting matching' do
          expect(subject).to include(recipe1)
        end
      end

      context 'when user has all ingredients' do
        let(:ingredients) { %w[onion garlic tomato oil potatos sugar pepper] }

        it 'returns array' do
          expect(subject).to eq [recipe1, recipe2, recipe3]
        end
      end
    end
  end
end
