# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipesController, type: :request do
  describe 'GET #index', type: :request do
    subject { get '/recipes', params: }

    context 'with no filters' do
      let(:params) { {} }

      it 'returns a list of recipes' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index view' do
        subject

        expect(response).to render_template(:index)
      end
    end

    context 'when filtering' do
      let(:params) do
        { filters: { ingredients: %w[eggs tomato] } }
      end

      before do
        create_list(:recipe, 3)
      end

      it 'Filter by_ingredients' do
        expect(Recipe).to receive(:by_ingredients)
          .with(%w[eggs tomato]).and_call_original
        expect(Recipe).to receive(:where).and_call_original
        subject
      end
    end
  end

  describe 'SHOW /recipes/:id', type: :request do
    subject { get "/recipes/#{record.id}" }

    let(:record) { create(:recipe) }

    it 'returns a single recipe' do
      expect(Recipe).to receive(:find).with(record.id.to_s).and_call_original

      subject
    end
  end
end
