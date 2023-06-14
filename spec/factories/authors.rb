# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  image      :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authors_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :author do
    name { Faker::Name.first_name }
    image { Faker::Internet.url }
  end
end
