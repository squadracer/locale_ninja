# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gemspec
gem 'async-http-faraday'
gem 'dry-auto_inject'
gem 'dry-container'
gem 'faraday'
gem 'httparty', '~> 0.21.0', require: false
gem 'octokit', '~> 5.0', require: false
gem 'puma'
gem 'sprockets-rails'
gem 'sqlite3'
gem 'tailwindcss-rails', '~> 2.0'

group :development, :test do
  gem 'pry-byebug'
  gem 'rack-mini-profiler'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'stackprof'
end

group :development do
  gem 'better_errors'
end

group :test do
  gem 'capybara', require: false
  gem 'selenium-webdriver', require: false
  gem 'webmock', require: false
end
