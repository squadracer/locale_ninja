# frozen_string_literal: true

module LocaleNinja
  require 'httparty'
  require 'json'
  require 'cgi'
  class LocalesController < ApplicationController
    skip_before_action :authenticate!, only: %i[github traverse]

    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET

    def index
      locales_yml = LocaleNinja::GithubService.new(access_token:).pull.map { YAML.load(_1) }
      @code_value_by_locales = locales_yml.to_h { [_1.keys[0], traverse(_1)] }
    end

    def show
      @locale = params[:locale]

      service = LocaleNinja::GithubService.new(access_token: session[:access_token])
      locale_files_path = service.locale_files_path.filter { |path| path.ends_with?("#{@locale}.yml") }
      hashes = service.pull(locale_files_path).map { |file| YAML.load(file) }
      @translations = hashes.map { |hash| traverse(hash).to_h }.reduce(&:merge)
    end

    def update
      params[:val]
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

    def github
      code = params['code']
      response = HTTParty.post('https://github.com/login/oauth/access_token',
                               body: {
                                 client_id: CLIENT_ID,
                                 client_secret: CLIENT_SECRET,
                                 code:
                               }
                              )
      parsed = CGI.parse(response)
      session[:access_token] = parsed['access_token'].first
      redirect_to('/locale_ninja')
    end

  end
end
