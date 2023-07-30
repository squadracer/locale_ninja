# frozen_string_literal: true

module LocaleNinja
  require 'httparty'
  require 'json'
  require 'cgi'
  class LocalesController < ApplicationController
    skip_before_action :authenticate!, only: %i[github]

    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET

    def show
      @locale = params[:locale]
      @branch_name = params[:branch_id]
      service = LocaleNinja::GithubService.new(access_token: session[:access_token])
      locale_files_path = service.locale_files_path.filter { |path| path.ends_with?("#{@locale}.yml") }
      hashes = service.pull(locale_files_path).transform_values { |file| YAML.load(file) }
      @translations = hashes.map { |path, hash| LocaleHelper.traverse(hash).to_h.transform_keys { |key| "#{path}$#{key}" } }.reduce(&:merge)
      LocaleHelper.missing_keys(@locale, service).each { |key| @translations[key] = '' }
    end

    def update
      translation_keys = params[:val].permit!.to_h.compact_blank
      yml = LocaleHelper.keys2yml(translation_keys)
      service = GithubService.new(access_token: session[:access_token])
      yml.each { |path, file| service.push(path, file) }
      service.pull_request('translations')
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
