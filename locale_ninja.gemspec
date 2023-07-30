# frozen_string_literal: true

require_relative 'lib/locale_ninja/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1.4'
  spec.name        = 'locale_ninja'
  spec.version     = LocaleNinja::VERSION
  spec.authors     = ['Julien Marseille', 'Théo Dupuis', 'Pierre Fitoussi', 'Clément Avenel']
  spec.email       = ['julien@squadracer.com', 'theo@squadracer.com', 'pierre@squadracer.com', 'clement@squadracer.com']
  spec.homepage    = 'https://locale-ninja.osc-fr1.scalingo.io/'
  spec.summary     = 'A git based gem to manage translations in a Ruby on Rails app.'
  spec.description = spec.summary
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

  spec.add_dependency('rails', '>= 7.0.6')
  spec.add_dependency('tailwindcss-rails', '>= 0.8.0')
end
