# frozen_string_literal: true

module LocaleNinja
  require 'octokit'
  require 'httparty'
  class ApplicationController < ::ApplicationController
    add_flash_types :alert, :info, :error, :warning, :success
    before_action :authenticate!, skip: :authenticate!
    rescue_from ::Octokit::Unauthorized, with: :clear_session

    CLIENT_ID = Rails.application.credentials.github.client_id
    TRANSLATIONS_SUFFIX = '__translations'

    private_constant :CLIENT_ID
    private_constant :TRANSLATIONS_SUFFIX

    def default_branch
      %w[main master].intersection(branch_names).first || branch_names.first
    end

    def branch_to_pull(branch = default_branch)
      translation_branch(branch) if branch?(translation_branch(branch))
    end

    def public_branch_names
      branch_names.reject { |branch| translation_branch?(branch) }
    end

    def translation_branch_names
      branch_names.filter { |branch| translation_branch?(branch) }
    end

    def branch?(branch_name)
      branch_names.include?(branch_name)
    end

    def translation_branch(branch)
      translation_branch?(branch) ? branch : "#{branch}#{TRANSLATIONS_SUFFIX}"
    end

    private

    def translation_branch?(branch_name)
      branch_name.ends_with?(TRANSLATIONS_SUFFIX)
    end

    def branch_names
      session[:branch_names]
    end

    def clear_session
      session.clear
      redirect_to(dashboard_index_path)
    end

    def set_client
      @client = GithubApiService.new(access_token:)
    end

    def access_token
      session.dig(:access, :access_token)
    end

    def authenticate!
      return if access_token

      redirect_to("https://github.com/login/oauth/authorize?&client_id=#{CLIENT_ID}")
    end
  end
end
