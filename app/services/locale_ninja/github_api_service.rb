# frozen_string_literal: true

module LocaleNinja
  class GithubApiService
    REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name

    private_constant :REPOSITORY_FULLNAME

    def initialize(access_token:)
      @client = ::Octokit::Client.new(access_token:)
    end

    attr_reader :client

    delegate :user, to: :@client
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

    def locale_files(dir = 'config/locales', branch: 'translations')
      return @locale_files if @locale_files.present?

      @locale_files = tree(REPOSITORY_FULLNAME, "heads/#{branch}", recursive: true).tree.select do |file|
        file.type == 'blob' && file.path.include?(dir)
      end
    end

    def locale_files_path(branch: 'translations')
      locale_files(branch:).map(&:path)
    end

    def pull(branch: 'translations')
      locale_files(branch:).to_h do |file|
        content = Base64.decode64(blob(REPOSITORY_FULLNAME, file.sha).content)
        [file.path, content]
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

    def create_pull_request(from, to)
      @client.create_pull_request(REPOSITORY_FULLNAME, from, to, "Translations for #{from}")
    rescue Octokit::UnprocessableEntity
    end

    def create_translation_branch(from, to)
      create_branch(from, to)
    end

    private

    def create_branch(parent_branch, child_branch)
      sha = ref(REPOSITORY_FULLNAME, "heads/#{parent_branch}").dig(:object, :sha)
      create_ref(REPOSITORY_FULLNAME, "heads/#{child_branch}", sha)
      child_branch
    end

    def create_file(file_path, content, branch: 'translations')
      create_contents(REPOSITORY_FULLNAME, file_path, "translations #{DateTime.current}", content, branch:)
    end
  end
end
