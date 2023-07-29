# frozen_string_literal: true

Rails.application.routes.draw do
  mount LocaleNinja::Engine => '/locale_ninja'
end
