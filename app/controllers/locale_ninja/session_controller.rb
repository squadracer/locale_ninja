# frozen_string_literal: true

module LocaleNinja
  class SessionController < ApplicationController
    skip_before_action :authenticate!, only: %i[login logout]

    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET

    def login
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
      user = GithubApiService.new(access_token:).user
      session[:user] = user.to_h.slice(:avatar_url, :id, :login)
      redirect_to(root_path)
    end

    def logout
      session.clear
      redirect_to('https://github.com/logout')
    end
  end
end
