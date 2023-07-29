# frozen_string_literal: true

module LocaleNinja
  class GithubService
    require 'octokit'

    GITHUB_ACCESS_TOKEN = Rails.application.credentials.github.access_token
    REPOSITORY_NAME = Rails.application.credentials.github.repository_name

    public_constant :GITHUB_ACCESS_TOKEN
    public_constant :REPOSITORY_NAME

    def self.call
      client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
      repository_name = client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
      repository = Octokit::Repository.new(repository_name)
      locale_files_path = client.contents(repository, path: 'config/locales').map(&:path)
      locale_files_path.map { |path| Base64.decode64(client.contents(repository, path:).content) }
    end

    def self.push(file_path, content)
      client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
      repository_name = client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
      sha = client.content(repository_name, path: file_path)[:sha]
      client.update_contents(repository_name,file_path,"translations #{DateTime.current}",sha,content, branch: 'translations')
    end
  end
end
