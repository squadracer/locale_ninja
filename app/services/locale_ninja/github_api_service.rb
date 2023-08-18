# frozen_string_literal: true

module LocaleNinja
  class GithubApiService
    REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name
    TRANSLATIONS_SUFFIX = '__translations'

    private_constant :REPOSITORY_FULLNAME
    private_constant :TRANSLATIONS_SUFFIX

    def initialize(access_token:)
      @client = ::Octokit::Client.new(access_token:)
    end

    attr_reader :client

    delegate :user, :branches, to: :@client
    delegate :blob, :commits_since, :content, :create_contents, :ref, :repository, :tree, :update_contents, :create_ref,
             to: :@client, private: true

    def repo_information
      repository(REPOSITORY_FULLNAME).to_h.slice(:full_name, :html_url)
    end

    def commits_count(branch: 'translations')
      commits_since(REPOSITORY_FULLNAME, 1.month.ago.strftime('%Y-%m-%d'), sha_or_branch: branch).count
    end

    def sum_commit_count(branches)
      branches.sum { |branch| commits_count(branch:) }
    end

    def default_branch
      pulled_branches_names.intersection(%w[main master]).first || pulled_branches_names.first
    end

    def pulled_branches
      @pulled_branches ||= branches(REPOSITORY_FULLNAME)
    end

    def pulled_branches_names
      @pulled_branches_names ||= pulled_branches.map { |branch| GitBranchName.new(branch.name) }
    end

    def displayable_branch_names
      pulled_branches_names.reject(&:translation?)
    end

    def translation_branch_names
      pulled_branches_names.filter(&:translation?)
    end

    def branch_pulled?(branch_name)
      pulled_branches_names.include?(branch_name)
    end

    def select_branch_to_pull(selected_branch)
      pulled_branches_names.find { |branch| branch == selected_branch.translation } || selected_branch.base
    end

    def locale_files_path(branch)
      locale_files(select_branch_to_pull(branch)).map(&:path)
    end

    def pull(branch)
      locale_files(select_branch_to_pull(branch)).to_h do |file|
        content = Base64.decode64(blob(REPOSITORY_FULLNAME, file.sha).content)
        [file.path, content]
      end
    end

    def save(branch, yml)
      create_branch(branch) unless branch_pulled?(branch.translation)
      push_modification(branch.translation, yml)
      create_pull_request(branch)
    end

    private

    def locale_files(branch, dir = 'config/locales')
      return @locale_files if @locale_files.present?

      @locale_files = tree(REPOSITORY_FULLNAME, "heads/#{branch}", recursive: true).tree.select do |file|
        file.type == 'blob' && file.path.include?(dir)
      end
    end

    def push_modification(branch, yml)
      yml.each { |path, file| push(path, file, branch:) }
    end

    def push(file_path, content, branch:)
      begin
        sha = content(REPOSITORY_FULLNAME, path: file_path, ref: "heads/#{branch}")[:sha]
      rescue Octokit::NotFound
        create_file(file_path, content, branch:)
        return
      end
      update_contents(REPOSITORY_FULLNAME, file_path, "translations #{DateTime.current}", sha, content, branch:)
    end

    def create_pull_request(branch)
      @client.create_pull_request(REPOSITORY_FULLNAME, branch, branch.translation, "Translations for #{branch}")
    rescue Octokit::UnprocessableEntity
    end

    def create_branch(branch)
      sha = ref(REPOSITORY_FULLNAME, "heads/#{branch}").dig(:object, :sha)
      create_ref(REPOSITORY_FULLNAME, "heads/#{branch.translation}", sha)
      branch.translation
    end

    def create_file(file_path, content, branch: 'translations')
      create_contents(REPOSITORY_FULLNAME, file_path, "translations #{DateTime.current}", content, branch:)
    end
  end
end
