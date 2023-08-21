# frozen_string_literal: true

module LocaleNinja
  require 'octokit'
  require 'httparty'
  class ApplicationController < ::ApplicationController
    include LocaleHelper

    add_flash_types :alert, :info, :error, :warning, :success
    before_action :authenticate!, skip: :authenticate!
    rescue_from ::Octokit::Unauthorized, with: :clear_session

    CLIENT_ID = LocaleNinja.configuration.client_id

    private_constant :CLIENT_ID

    private

    def clear_session
      session.clear
      redirect_to(dashboard_index_path)
    end

    def set_client
      @client = LocaleNinja.configuration.service.call.new(access_token:)
    end

    def access_token
      session[:access_token]
    end

    def authenticate!
      return if access_token

      redirect_to("https://github.com/login/oauth/authorize?&client_id=#{CLIENT_ID}", allow_other_host: true)
    end
  end
end
