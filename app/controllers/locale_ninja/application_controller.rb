# frozen_string_literal: true

module LocaleNinja
  class ApplicationController < ActionController::Base
    before_action :authenticate!

    CLIENT_ID = Rails.application.credentials.github.client_id
    private_constant :CLIENT_ID

    private

    def set_client
      @client = GithubApiService.new(access_token:)
    end

    def access_token
      session[:access_token]
    end

    def authenticate!
      return if access_token

      redirect_to("https://github.com/login/oauth/authorize?scope=repo,user&client_id=#{CLIENT_ID}", allow_other_host: true)
    end
  end
end
