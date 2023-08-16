# frozen_string_literal: true

require 'rails/generators'

module LocaleNinja
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Install LocaleNinja in your Ruby on Rails application'

      def prompt_mount_path
        default_mount_path = '/locale_ninja'
        @mount_path = ask("Enter the mount path for LocaleNinja engine (default: #{default_mount_path}):")
        @mount_path = default_mount_path if @mount_path.blank?
      end

      def add_locale_ninja_route
        route("mount LocaleNinja::Engine => '#{@mount_path}'")
      end

      def display_instructions
        say('LocaleNinja has been successfully installed and configured!', :green)
        say('Please make sure to follow any additional setup steps as mentioned in the README.')
      end
    end
  end
end
