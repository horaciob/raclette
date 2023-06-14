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
class Recipe < ApplicationRecord
  validates :cook_time, :prep_time, :title, presence: true

  belongs_to :author, optional: true
  belongs_to :category, optional: true

  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients
  paginates_per 50
  max_paginates_per 100
end
