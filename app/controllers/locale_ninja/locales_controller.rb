# frozen_string_literal: true

module LocaleNinja
  require 'httparty'
  require 'json'
  require 'cgi'
  class LocalesController < ApplicationController
    skip_before_action :authenticate!, only: %i[github]
    before_action :set_client, only: %i[show update]

    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET

    def show
      @locale = params[:locale]
      @branch_name = params[:branch_id]
      locale_files_path = @client.locale_files_path(branch: @branch_name).filter { |path| path.ends_with?("#{@locale}.yml") }
      hashes = @client.pull(locale_files_path, branch: @branch_name).transform_values { |file| YAML.load(file) }
      @translations = hashes.map { |path, hash| LocaleHelper.traverse(hash).to_h.transform_keys { |key| "#{path}$#{key}" } }.reduce(&:merge)
      LocaleHelper.missing_keys(@locale, @client, branch: @branch_name).each { |key| @translations[key] = '' }
    end

    def update
      @branch_name = params[:branch_id]
      translation_keys = params[:val].permit!.to_h.compact_blank
      yml = LocaleHelper.keys2yml(translation_keys)
      yml.each { |path, file| @client.push(path, file, branch: @branch_name) }
      @client.pull_request('translations')
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
