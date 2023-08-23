# frozen_string_literal: true

require 'locale_ninja/version'
require 'locale_ninja/engine'
require 'locale_ninja/configuration'

module LocaleNinja
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
