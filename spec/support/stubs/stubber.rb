# frozen_string_literal: true

module Stubber
  GITHUB_API_URL = 'https://api.github.com'
  REPOSITORY_FULLNAME = LocaleNinja.configuration.repository

  private_constant :GITHUB_API_URL
  private_constant :REPOSITORY_FULLNAME
  def access_token_stub
    stub_request(:post, 'https://github.com/login/oauth/access_token')
      .with(
        body: '{"code":"123456","client_id":123456,"client_secret":1234567890}',
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Basic MTIzNDU2OjEyMzQ1Njc4OTA=',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Octokit Ruby Gem 5.6.1'
        }
      )
      .to_return(status: 200, body: { access_token: 'random_token', refresh_token: 'random_refresh_token' }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def github_repo_stub(method, host, body = '')
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

  def github_user_stub(body = '')
    stub_request(:get, "#{GITHUB_API_URL}/user")
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
