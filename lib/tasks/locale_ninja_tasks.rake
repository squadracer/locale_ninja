# frozen_string_literal: true

task tailwind_engine_watch: :environment do
  require 'tailwindcss-rails'

  system "#{Tailwindcss::Engine.root.join('exe/tailwindcss')} \
         -i #{LocaleNinja::Engine.root.join('app/assets/stylesheets/application.tailwind.css')} \
         -o #{LocaleNinja::Engine.root.join('app/assets/builds/locale_ninja.css')} \
         -c #{LocaleNinja::Engine.root.join('config/tailwind.config.js')} \
         --minify -w"
end
