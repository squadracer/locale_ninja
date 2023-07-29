# frozen_string_literal: true

module LocaleNinja
  class ApplicationController < ActionController::Base
    before_action :authenticate!

    CLIENT_ID = ENV.fetch('GITHUB_CLIENT_ID', '')
    public_constant :CLIENT_ID

    private

    def access_token
      session[:access_token]
    end

    def authenticate!
      return if access_token

      redirect_to("https://github.com/login/oauth/authorize?scope=repo,user&client_id=#{CLIENT_ID}")
    end
  end
end
