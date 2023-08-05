# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Specify your gem's dependencies in locale_ninja.gemspec.
gemspec

gem 'puma'

gem 'sqlite3'

gem 'sprockets-rails'

gem 'octokit', '~> 5.0', require: false

gem 'httparty', '~> 0.21.0', require: false

group :development, :test do
  gem 'pry-byebug'
  gem 'rack-mini-profiler'
  gem 'stackprof'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'better_errors'
end

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

gem 'tailwindcss-rails', '~> 2.0'
