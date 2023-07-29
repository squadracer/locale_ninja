# frozen_string_literal: true

module LocaleNinja
  require 'httparty'
  require 'json'
  require 'cgi'
  class LocalesController < ApplicationController
    def index
      locales_yml = LocaleNinja::GithubService.call.map { YAML.load(_1) }

      @code_value_by_locales = locales_yml.to_h { [_1.keys[0], traverse(_1)] }
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
    
    def login; end

    def github
      code = params['code']
      response = HTTParty.post('https://github.com/login/oauth/access_token',
                               body: {
                                 client_id: ENV.fetch('GITHUB_CLIENT_ID', nil),
                                 client_secret: ENV.fetch('GITHUB_APP_SECRET', nil),
                                 code:
                               }
                              )
      parsed = CGI::parse(response)
      client = Octokit::Client.new(access_token: parsed['access_token'].first)
    end
  end
end
