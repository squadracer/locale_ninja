# frozen_string_literal: true

module LocaleNinja
  class Engine < ::Rails::Engine
    isolate_namespace LocaleNinja

    initializer 'locale_ninja.assets' do |app|
      app.config.assets.precompile += %w[locale_ninja_manifest locale_ninja/application.css locale_ninja/application.js locale_ninja.css]
    end
  end
end
