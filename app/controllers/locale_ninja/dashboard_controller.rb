# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    def index
      @yml_locales = GithubService.new(access_token:).pull.values.map { YAML.load(_1) }
    end
  end
end
