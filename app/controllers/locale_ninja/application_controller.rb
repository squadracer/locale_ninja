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
      if access_token
        begin
          LocaleNinja::GithubService.new(access_token:).call.map { YAML.load(_1) }
        rescue StandardError
          # request didn't succeed because the token was revoked so we
          # invalidate the token stored in the session and render the
          # index page so that the user can start the OAuth flow again
          session[:access_token] = nil
          authenticate!
        end
      else
        redirect_to("https://github.com/login/oauth/authorize?scope=repo,user&client_id=#{CLIENT_ID}")
      end
    end
  end
end
