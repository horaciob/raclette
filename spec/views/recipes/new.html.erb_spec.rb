# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipes/new' do
  before do
    assign(:recipe, Recipe.new(
                      title: 'MyString',
                      cook_time: 1,
                      prep_time: 1,
                      rating: 1.5,
                      author: nil,
                      category: nil
                    ))
  end

  it 'renders new recipe form' do
    render

    assert_select 'form[action=?][method=?]', recipes_path, 'post' do
      assert_select 'input[name=?]', 'recipe[title]'

      assert_select 'input[name=?]', 'recipe[cook_time]'

      assert_select 'input[name=?]', 'recipe[prep_time]'

      assert_select 'input[name=?]', 'recipe[rating]'

      assert_select 'input[name=?]', 'recipe[author_id]'

      assert_select 'input[name=?]', 'recipe[category_id]'
    end
  end
end
