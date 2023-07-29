# frozen_string_literal: true

module LocaleNinja
  class Engine < ::Rails::Engine
    isolate_namespace LocaleNinja

    initializer 'assets' do |app|
      app.config.assets.precompile += %w[locale_ninja_manifest]
    end
  end
end
