# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_client, only: [:index]

    def index
      @locales_count = @client.locale_files_path(branch: @client.default_branch).count
      @repo = @client.repo_information
      @branches_count = @client.public_branch_names.count
      @total_translation_commits_count = @client.total_translation_commits_count
    end
  end
end
