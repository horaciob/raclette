# frozen_string_literal: true

Rails.application.routes.draw do
  resources :recipes
  root 'recipes#index'
  get '/health_check', to: proc { [200, {}, ['success']] }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
