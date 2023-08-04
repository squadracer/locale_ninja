# frozen_string_literal: true

module LocaleNinja
  class GithubApiService
    REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name
    private_constant :REPOSITORY_FULLNAME

    def initialize(access_token:)
      @client = ::Octokit::Client.new(access_token:)
    end

    attr_reader :client

    def user
      @client.user
    end

    def translation_branch(branch)
      branch.ends_with?('__translations') ? branch : "#{branch}__translations"
    end

    def locale_files(dir = 'config/locales', branch: 'translations')
      branch = translation_branch(branch) if branch?(translation_branch(branch))
      @client.tree(repository_fullname, "heads/#{branch}", recursive: true).tree.select do |file|
        file.type == 'blob' && file.path.include?(dir)
      end
    end

    def locale_files_path(branch: 'translations')
      locale_files(branch:).map(&:path)
    end

    def pull(branch: 'translations')
      result = {}
      locale_files(branch:).each do |file|
        content = Base64.decode64(@client.blob(repository_fullname, file.sha).content)
        result[file.path] = content
      end
      result
    end

    def create_translation_branch(branch)
      return branch if branch.ends_with?('__translations')

      translation_branch = "#{branch}__translations"
      return translation_branch if branch?(translation_branch)

      create_branch(branch, translation_branch)
      translation_branch
    end

    def push(file_path, content, branch: 'translations')
      branch = create_translation_branch(branch)

      begin
        sha = @client.content(repository_fullname, path: file_path, ref: "heads/#{branch}")[:sha]
      rescue ::Octokit::NotFound
        create_file(file_path, content, branch:)
        return
      end
      @client.update_contents(repository_fullname, file_path, "translations #{DateTime.current}", sha, content, branch:)
    end

    def create_file(file_path, content, branch: 'translations')
      @client.create_contents(repository_fullname, file_path, "translations #{DateTime.current}", content, branch:)
    end

    def create_branch(parent_branch, child_branch)
      sha = @client.ref(repository_fullname, "heads/#{parent_branch}").dig(:object, :sha)
      @client.create_ref(repository_fullname, "heads/#{child_branch}", sha)
      @branches << child_branch
    end

    def branch?(branch_name)
      branch_names.include?(branch_name)
    end

    def repository_fullname
      @repository_fullname ||= REPOSITORY_FULLNAME
    end

    def repo_information
      @client.repository(repository_fullname).to_h.slice(:full_name, :html_url)
    end

    def branches
      @branches ||= @client.branches(repository_fullname)
    end

    def branch_names
      @branch_names ||= branches.map(&:name)
    end

    def default_branch
      %w[main master].find { |branch_name| branch_names.include?(branch_name) } || branch_names.first
    end

    def public_branch_names
      branch_names.reject { |branch| branch.ends_with?('__translations') }
    end

    def pull_request(branch_name)
      @client.create_pull_request(repository_fullname, branch_name, "#{branch_name}__translations", "translations #{Time.current}")
    rescue ::Octokit::UnprocessableEntity
      # If pull request already exists, do nothing
    end
  end
end
