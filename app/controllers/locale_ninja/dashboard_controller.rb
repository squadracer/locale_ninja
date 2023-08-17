# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_client, only: [:index]

    def index
      @locales_count = @client.locale_files_path(branch: branch_to_pull).count
      @repo = @client.repo_information
      @branches_count = public_branch_names.count
      @total_translation_commits_count = @client.sum_commit_count(translation_branch_names)
    end
  end
end
