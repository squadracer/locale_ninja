# frozen_string_literal: true

module LocaleNinja
  class SessionController < ApplicationController
    skip_before_action :authenticate!, only: %i[login logout]

    def login
      code = params['code']
      tokens = GithubClient::Insecure.new.get_access_token(code)
      session[:access] = tokens
      session[:user] = GithubClient::Secure.new(session.dig(:access, :access_token)).user.slice(:avatar_url, :id, :login)
      redirect_to(root_path)
    end

    def logout
      session.clear
      redirect_to('https://github.com/logout')
    end
  end
end
