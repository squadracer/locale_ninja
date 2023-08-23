# frozen_string_literal: true

module LocaleNinja
  class Configuration
    class ConfigurationError < StandardError; end

    PLATEFORM_SERVICE_MAP = {
      github: -> { LocaleNinja::GithubService }
    }.freeze
    private_constant :PLATEFORM_SERVICE_MAP

    attr_accessor :repository, :client_id, :client_secret, :branch_suffix
    attr_writer :default_branch

    def default_branch
      GitBranchName.new @default_branch
    end

    def service
      @service.call
    end

    def plateform=(plateform)
      raise ConfigurationError, "#{plateform} is not included in #{PLATEFORM_SERVICE_MAP.keys.join}" unless PLATEFORM_SERVICE_MAP.key?(plateform)

      @service = PLATEFORM_SERVICE_MAP[plateform]
    end
  end
end
