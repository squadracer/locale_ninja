# frozen_string_literal: true

module LocaleNinja
  class SessionController < ApplicationController
    skip_before_action :authenticate!, only: %i[login logout]

    def login
      code = params['code']
      session[:access] = Github::Client.get_access_token(code)
      access_token = session.dig(:access, :access_token)
      user = Github::Client.new(access_token).user
      session[:user] = user.slice(:avatar_url, :id, :login)

      redirect_to(root_path)
    end

    def logout
      session.clear
      redirect_to('https://github.com/logout')
    end
  end
end
