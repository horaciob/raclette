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
#  index_recipes_on_author_id            (author_id)
#  index_recipes_on_author_id_and_title  (author_id,title) UNIQUE
#  index_recipes_on_category_id          (category_id)
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

    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:author_id) }
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
end
