# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipes/edit' do
  let(:recipe) do
    Recipe.create!(
      title: 'MyString',
      cook_time: 1,
      prep_time: 1,
      rating: 1.5,
      author: nil,
      category: nil
    )
  end

  before do
    assign(:recipe, recipe)
  end

  it 'renders the edit recipe form' do
    render

    assert_select 'form[action=?][method=?]', recipe_path(recipe), 'post' do
      assert_select 'input[name=?]', 'recipe[title]'

      assert_select 'input[name=?]', 'recipe[cook_time]'

      assert_select 'input[name=?]', 'recipe[prep_time]'

      assert_select 'input[name=?]', 'recipe[rating]'

      assert_select 'input[name=?]', 'recipe[author_id]'

      assert_select 'input[name=?]', 'recipe[category_id]'
    end
  end
end
