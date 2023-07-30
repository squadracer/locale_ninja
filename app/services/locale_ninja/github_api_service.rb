# frozen_string_literal: true

module LocaleNinja
  class GithubApiService
    require 'octokit'

    REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name

    private_constant :REPOSITORY_FULLNAME

    def initialize(access_token:)
      @client = Octokit::Client.new(access_token:)
    end

    def locale_files_path(dir = 'config/locales', branch: 'translations')
      @client.contents(repository_fullname, path: dir, ref: "heads/#{branch}").map do |file|
        if file.type == 'dir'
          locale_files_path(file.path)
        else
          file.path
        end
      end.flatten
    end

    def pull(file = locale_files_path, branch: 'translations')
      branch = 'main' unless branch?(branch)
      file.index_with { |path| Base64.decode64(@client.contents(repository_fullname, path:, ref: "heads/#{branch}").content) }
    end

    def push(file_path, content, branch: 'translations')
      create_branch('main', branch) unless branch?(branch)
      begin
        sha = @client.content(repository_fullname, path: file_path, ref: "heads/#{branch}")[:sha]
      rescue Octokit::NotFound
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
    end

    def branch?(branch_name)
      @client.ref(repository_fullname, "heads/#{branch_name}")
    rescue Octokit::NotFound
      nil
    end

    def repository_fullname
      @repository_fullname ||= REPOSITORY_FULLNAME
    end

    def branches
      @client.branches(repository_fullname).map(&:name)
    end

    def pull_request(branch_name)
      @client.create_pull_request(repository_fullname, 'main', branch_name, "translations #{Time.current}")
    rescue Octokit::UnprocessableEntity
      # If pull request already exists, do nothing
    end
  end
end
