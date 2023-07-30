# frozen_string_literal: true

module LocaleNinja
  class DashboardController < ApplicationController
    before_action :set_client, only: [:index]

    def index
      @locales_count = LocaleHelper.locales_count(@client)
      translation_branches = @client.branches.filter { |branch| branch.ends_with?('__translations') }
      @branches_count = @client.branches.count - translation_branches.count
      @commits_count = translation_branches.sum do |branch|
        @client.client.commits_since(@client.repository_fullname,
                                     1.month.ago.strftime('%Y-%m-%d'),
                                     sha_or_branch: branch
                                    ).count
      end
    end
  end
end
