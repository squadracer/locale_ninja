# frozen_string_literal: true

module LocaleNinja
  class SessionController < ApplicationController
    skip_before_action :authenticate!, only: %i[login logout]
    before_action :set_service, only: :login

    def login
      code = params['code']
      session[:access_token] = @service.code_for_token(code)
      session[:user] = @service.user.to_h.slice(:avatar_url, :id, :login)

      redirect_to(root_path)
    end

    def logout
      session.clear
      redirect_to('https://github.com/logout')
    end
  end
end
