# frozen_string_literal: true

module LocaleNinja
  class LocalesController < ApplicationController
    def index
      @yml_locales = GithubService.call.map{YAML.load(_1)}
    end
  end
end
