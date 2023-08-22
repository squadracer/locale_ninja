# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_service, only: [:index]

    def index
      @locales_count = @service.locale_files_path(@service.default_branch).count
      @repo = @service.repo_information
      @branches_count = @service.displayable_branch_names.count
      @total_translation_commits_count = @service.sum_commit_count(@service.translation_branch_names)
    end
  end
end
