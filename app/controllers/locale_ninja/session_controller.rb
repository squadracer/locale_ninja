# frozen_string_literal: true

module LocaleNinja
  class SessionController < ApplicationController
    skip_before_action :authenticate!, only: %i[login logout]

    def login
      code = params['code']
      tokens = Github::Client.get_access_token(code)
      session[:access] = tokens
      session[:user] = Github::Client.new(session.dig(:access, :access_token)).user.slice(:avatar_url, :id, :login)
      branches = Github::Client.new(session.dig(:access, :access_token)).branches
      binding.pry
      session[:branch_names] = branches.pluck(:name)
      redirect_to(root_path)
    end

    def logout
      session.clear
      redirect_to('https://github.com/logout')
    end
  end
end
