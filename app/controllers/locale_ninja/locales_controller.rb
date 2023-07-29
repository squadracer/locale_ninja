# frozen_string_literal: true

module LocaleNinja
  class LocalesController < ApplicationController
    def index
      locales_yml = LocaleNinja::GithubService.call.map { YAML.load(_1) }

      @code_value_by_locales = locales_yml.to_h { [_1.keys[0], traverse(_1)] }
    end

    def github
      # pour voir le retour de la github app
      @content = params.inspect
    end

    def traverse(hash, parent_key = nil)
      path = []
      hash.each do |key, value|
        current_key = parent_key ? "#{parent_key}.#{key}" : key.to_s
        if value.is_a?(Hash)
          path += traverse(value, current_key)
        else
          path << [current_key, value]
        end
      end
      path
    end
  end
end
