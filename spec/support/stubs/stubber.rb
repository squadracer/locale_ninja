# frozen_string_literal: true

module Stubber
  GITHUB_API_URL = 'https://api.github.com'
  REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name
  CLIENT_ID = Rails.application.credentials.github.client_id
  CLIENT_SECRET = Rails.application.credentials.github.client_secret

  private_constant :GITHUB_API_URL
  private_constant :REPOSITORY_FULLNAME
  private_constant :CLIENT_ID
  private_constant :CLIENT_SECRET

  def access_token_stub
    stub_request(:post, 'https://github.com/login/oauth/access_token')
      .with(
        body: { 'client_id' => CLIENT_ID, 'client_secret' => CLIENT_SECRET, 'code' => '123456' }.to_json,
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Faraday v2.7.10'
        }
      )
      .to_return(status: 200, body: 'access_token=random_token&expires_in=28800&refresh_token=random_refresh_token&refresh_token_expires_in=15897600&scope=&token_type=bearer', headers: {})
  end

  def github_octokit_stub(method, host, body = '')
    stub_request(method, "#{GITHUB_API_URL}/repos/#{REPOSITORY_FULLNAME}#{host}")
      .with(
        headers: {
          'Accept' => 'application/vnd.github.v3+json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'token random_token',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Octokit Ruby Gem 5.6.1'
        }
      )
      .to_return(status: 200, body:, headers: { 'Content-Type' => 'application/json' })
  end

  def github_faraday_stub(method, host, body = '')
    stub_request(method, "#{GITHUB_API_URL}#{host}")
      .with(
        headers: {
          'Accept' => 'application/vnd.github+json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer random_token',
          'User-Agent' => 'Faraday v2.7.10'
        }
      ).to_return(status: 200, body:, headers: { 'Content-Type' => 'application/json' })
  end
end
