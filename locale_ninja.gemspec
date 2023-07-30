# frozen_string_literal: true

require_relative 'lib/locale_ninja/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1.4'
  spec.name        = 'locale_ninja'
  spec.version     = LocaleNinja::VERSION
  spec.authors     = ['Julien Marseille', 'Théo Dupuis', 'Pierre Fitoussi', 'Clément Avenel']
  spec.email       = 'contact@squadracer.com'
  spec.homepage    = 'https://locale-ninja.osc-fr1.scalingo.io/'
  spec.summary     = 'A git based gem to manage translations in a Ruby on Rails app.'
  spec.description = 'LocaleNinja is a powerful Git-based gem for effortless translation management in Ruby on Rails apps.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/squadracer/locale_ninja'
  spec.metadata['changelog_uri'] = 'https://github.com/squadracer/locale_ninja/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency('faraday-retry', '~> 2.2', '>= 2.2.0')
  spec.add_dependency('httparty', '~> 0.21', '>= 0.21.0')
  spec.add_dependency('octokit', '~> 5', '>= 5.0.0')
  spec.add_dependency('rails', '~> 7.0', '>= 7.0.6')
  spec.add_dependency('tailwindcss-rails', '~> 2.0', '>= 2.0.0')
end
