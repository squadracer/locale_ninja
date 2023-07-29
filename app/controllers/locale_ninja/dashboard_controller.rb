# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    def index
      @yml_locales = LocaleNinja::GithubService.new(access_token:).call.map { YAML.load(_1) }
    end
  end
end