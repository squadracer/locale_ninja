class GithubService
  require 'octokit'

  GITHUB_ACCESS_TOKEN = Rails.application.config.github_access_token
  REPOSITORY_NAME = Rails.application.config.github_repository_name

  def self.call
    client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
    repository_name = client.repositories.find { |repo| repo[:name] == REPOSITORY_NAME }[:full_name]
    repository = Octokit::Repository.new(repository_name)
    locale_files_path = client.contents(repository, path:'config/locales').map(&:path)
    locale_files = locale_files_path.map { |path| Base64.decode64(client.contents(repository, path: path).content) }
    puts locale_files.join("\n\n")
  end
end