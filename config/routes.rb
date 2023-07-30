# frozen_string_literal: true

LocaleNinja::Engine.routes.draw do
  root to: 'dashboard#index'

  resources :dashboard, only: [:index]
  post 'branch/select', to: 'branches#select'
  resources :branches, only: %i[index show] do
    resources :locales, only: %i[index show update], param: :locale
  end
  get '/github', to: 'locales#github'
end
