# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_service, only: [:index]

    def index
      @locales_count = @service.locale_files_path.count
      @repo = @service.repo_information
      @branches_count = @service.displayable_branch_names.count
      @total_translation_commits_count = @service.translation_commits_count
    end
  end
end
