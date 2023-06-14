# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipes/show' do
  before do
    assign(:recipe, Recipe.create!(
                      title: 'Title',
                      cook_time: 2,
                      prep_time: 3,
                      rating: 4.5,
                      author: nil,
                      category: nil
                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
