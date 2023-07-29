# frozen_string_literal: true

class GithubService
  require 'octokit'

  public_constant :GITHUB_ACCESS_TOKEN
  public_constant :REPOSITORY_NAME

  GITHUB_ACCESS_TOKEN = Rails.application.secrets.github.access_token
  REPOSITORY_NAME = Rails.application.secrets.github.repository_name

  def self.call
    client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
    repository_name = client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
    repository = Octokit::Repository.new(repository_name)
    locale_files_path = client.contents(repository, path: 'config/locales').map(&:path)
    locale_files_path.map { |path| Base64.decode64(client.contents(repository, path:).content) }
  end
end
