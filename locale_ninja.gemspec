require_relative "lib/locale_ninja/version"

Gem::Specification.new do |spec|
  spec.name        = "locale_ninja"
  spec.version     = LocaleNinja::VERSION
  spec.authors     = ["Julien Marseille"]
  spec.email       = ["julien@squadracer.com"]
  spec.homepage    = "https://squadracer.com"
  spec.summary     = "Summary of LocaleNinja."
  spec.description = "Description of LocaleNinja."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.6"
end
