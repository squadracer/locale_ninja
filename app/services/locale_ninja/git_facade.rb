# frozen_string_literal: true

require_relative '../../../lib/locale_ninja/plateform_container'

module LocaleNinja
  class GitFacade
    include LocaleNinja::GitService['git_service']

    delegate :repo_information, :commits_count, :sum_commit_count,
             :default_branch, :displayable_branch_names, :translation_branch_names,
             :locale_files_path, :pull, :save, to: :git_service
    delegate :token, to: :git_service
  end
end
