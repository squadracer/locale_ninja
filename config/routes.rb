# frozen_string_literal: true

LocaleNinja::Engine.routes.draw do
    resources :locales, only: [:index, :show], path: "/"
end
