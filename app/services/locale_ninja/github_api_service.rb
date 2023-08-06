# frozen_string_literal: true

module LocaleNinja
  class GithubApiService
    REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name
    TRANSLATIONS_SUFFIX = '__translations'

    public_constant :REPOSITORY_FULLNAME
    public_constant :TRANSLATIONS_SUFFIX

    def initialize(access_token:)
      @client = ::Octokit::Client.new(access_token:)
    end

    attr_reader :client

    delegate :user, :repository, :update_contents, :create_contents, :ref, :content, :blob, :tree, to: :@client

    def repo_information
      repository(REPOSITORY_FULLNAME).to_h.slice(:full_name, :html_url)
    end

    def branches
      @branches ||= @client.branches(REPOSITORY_FULLNAME)
    end

    def branch_names
      @branch_names ||= branches.map(&:name)
    end

    def default_branch
      %w[main master].find { |branch_name| branch_names.include?(branch_name) } || branch_names.first
    end

    def public_branch_names
      branch_names.reject { |branch| branch.ends_with?(TRANSLATIONS_SUFFIX) }
    end

    def locale_files(dir = 'config/locales', branch: 'translations')
      return @locale_files if @locale_files.present?

      branch = translation_branch(branch) if branch?(translation_branch(branch))
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

    def push(file_path, content, branch: 'translations')
      branch = create_translation_branch(branch)

      begin
        sha = content(REPOSITORY_FULLNAME, path: file_path, ref: "heads/#{branch}")[:sha]
      rescue Octokit::NotFound
        create_file(file_path, content, branch:)
        return
      end
      update_contents(REPOSITORY_FULLNAME, file_path, "translations #{DateTime.current}", sha, content, branch:)
    end

    def pull_request(branch_name)
      branch = "#{branch_name}#{TRANSLATIONS_SUFFIX}"
      create_contents(REPOSITORY_FULLNAME, branch_name, branch, "translations #{Time.current}")
    rescue Octokit::UnprocessableEntity
      # If pull request already exists, do nothing
    end

    private

    def branch?(branch_name)
      branch_names.include?(branch_name)
    end

    def translation_branch(branch)
      branch.ends_with?(TRANSLATIONS_SUFFIX) ? branch : "#{branch}#{TRANSLATIONS_SUFFIX}"
    end

    def create_translation_branch(branch)
      return branch if branch.ends_with?(TRANSLATIONS_SUFFIX)

      translation_branch = "#{branch}#{TRANSLATIONS_SUFFIX}"
      return translation_branch if branch?(translation_branch)

      create_branch(branch, translation_branch)
      translation_branch
    end

    def create_branch(parent_branch, child_branch)
      sha = ref(REPOSITORY_FULLNAME, "heads/#{parent_branch}").dig(:object, :sha)
      create_ref(REPOSITORY_FULLNAME, "heads/#{child_branch}", sha)
      @branches << child_branch
    end

    def create_file(file_path, content, branch: 'translations')
      create_contents(REPOSITORY_FULLNAME, file_path, "translations #{DateTime.current}", content, branch:)
    end
  end
end
