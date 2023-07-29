# frozen_string_literal: true

module LocaleNinja
  class GithubService
    require 'octokit'

    GITHUB_ACCESS_TOKEN = Rails.application.credentials.github.access_token
    REPOSITORY_NAME = Rails.application.credentials.github.repository_name

    public_constant :GITHUB_ACCESS_TOKEN
    public_constant :REPOSITORY_NAME

    def initialize(access_token:)
      @client = Octokit::Client.new(access_token:)
    end

    def local_files_path
      repository_name = @client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
      repository = Octokit::Repository.new(repository_name)
      @client.contents(repository, path: 'config/locales').map(&:path)
    end

    def pull
      local_files_path.map { |path| Base64.decode64(@client.contents(repository, path:).content) }
    end

    def push(file_path, content)
      repository_name = @client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
      sha = @client.content(repository_name, path: file_path)[:sha]
      @client.update_contents(repository_name, file_path, "translations #{DateTime.current}", sha, content, branch: 'translations')
    end

    def create_branch(parent_branch, child_branch)
      repository_name = @client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
      sha = @client.ref(repository_name, "heads/#{parent_branch}").dig(:object, :sha)
      @client.create_ref(repository_name, "heads/#{child_branch}", sha)
    end

    def branch?(branch_name)
      repository_name = @client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
      begin
        @client.ref(repository_name, "heads/#{parent_branch}").dig(:object, :sha)
      rescue Octokit::NotFound => e
        nil
      end
    end
  end
end
