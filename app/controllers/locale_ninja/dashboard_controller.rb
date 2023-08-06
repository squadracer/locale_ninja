# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_client, only: [:index]

    def index
      @locales_count = LocaleHelper.locales_count(@client, @client.default_branch)
      @repo = @client.repo_information
      translation_branches = @client.branch_names.filter { |branch_name| branch_name.ends_with?(GithubApiService::TRANSLATIONS_SUFFIX) }
      @branches_count = @client.branches.count - translation_branches.count
      @commits_count = translation_branches.sum do |branch|
        @client.client.commits_since(GithubApiService::REPOSITORY_FULLNAME,
                                     1.month.ago.strftime('%Y-%m-%d'),
                                     sha_or_branch: branch
                                    ).count
      end
    end
  end
end
