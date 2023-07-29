# frozen_string_literal: true

module LocaleNinja
  class LocalesController < ApplicationController
    def index
      @yml_locales = GithubService.call.map { YAML.load(_1) }
    end

    def github
      # pour voir le retour de la github app
      @content1 = params.inspect
    end
  end
end
