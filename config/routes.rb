# frozen_string_literal: true

LocaleNinja::Engine.routes.draw do
  root to: 'dashboard#index'

  resources :dashboard, only: [:index]
  resources :locales, only: %i[index show], param: :locale
  get '/github', to: 'locales#github'
end
