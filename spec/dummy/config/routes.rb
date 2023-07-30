# frozen_string_literal: true

Rails.application.routes.draw do
  root 'application#index'
  get 'index', to: 'application#index'
  mount LocaleNinja::Engine => '/locale_ninja'
end
