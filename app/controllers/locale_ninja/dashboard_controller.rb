# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_client, only: [:index]

    def index
      @yml_locales = @client.pull.values.map { YAML.load(_1) }
    end
  end
end
