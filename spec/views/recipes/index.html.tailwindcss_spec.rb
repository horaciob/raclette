# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipes/index' do
  before do
    assign(:recipes, [
             Recipe.create!(
               title: 'Title',
               cook_time: 2,
               prep_time: 3,
               rating: 4.5,
               author: nil,
               category: nil
             ),
             Recipe.create!(
               title: 'Title',
               cook_time: 2,
               prep_time: 3,
               rating: 4.5,
               author: nil,
               category: nil
             )
           ])
  end

  it 'renders a list of recipes' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Title'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
