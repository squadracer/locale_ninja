# frozen_string_literal: true

#require_relative '../../app/services/locale_ninja/github_api_service'

module LocaleNinja
  class Configuration
    class PlateformMisMatch < StandardError; end

    PLATEFORM_SERVICE_MAP = {
      github: -> { LocaleNinja::GithubApiService }
    }.freeze
    private_constant :PLATEFORM_SERVICE_MAP

    attr_accessor :repository, :client_id, :client_secret
    attr_reader :service

    def plateform=(plateform)
      raise(PlateformMisMatch, "#{plateform} is not included in #{PLATEFORM_SERVICE_MAP.keys.join}") unless PLATEFORM_SERVICE_MAP.key?(plateform)

      @service = PLATEFORM_SERVICE_MAP[plateform]
    end
  end
end
