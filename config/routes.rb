# frozen_string_literal: true

LocaleNinja::Engine.routes.draw do
  root to: 'dashboard#index'

  resources :dashboard, only: [:index]
  resources :locales, only: [:index]
  get '/github', to: 'locales#github'
end
