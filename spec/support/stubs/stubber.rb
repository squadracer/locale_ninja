# frozen_string_literal: true

module Stubber
  GITHUB_API_URL = 'https://api.github.com'
  REPOSITORY_FULLNAME = LocaleNinja.configuration.repository

  private_constant :GITHUB_API_URL
  private_constant :REPOSITORY_FULLNAME

  def access_token_stub(code)
    stub_request(:post, 'https://github.com/login/oauth/access_token')
      .with(
        body: "{\"code\":\"#{code}\",\"client_id\":\"<<CLIENT_ID>>\",\"client_secret\":\"<<CLIENT_SECRET>>\"}",
        headers: github_web_headers
      )
      .to_return(status: 200, body: { access_token: 'random_token', refresh_token: 'random_refresh_token' }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def github_repo_stub(method, host, body = '')
    stub_request(method, "#{GITHUB_API_URL}/repos/#{REPOSITORY_FULLNAME}#{host}")
      .with(
        headers: github_api_headers
      )
      .to_return(status: 200, body:, headers: { 'Content-Type' => 'application/json' })
  end

  def github_user_stub(body = '')
    stub_request(:get, "#{GITHUB_API_URL}/user")
      .with(headers: github_api_headers)
      .to_return(status: 200, body:, headers: { 'Content-Type' => 'application/json' })
  end

  private

  def github_web_headers
    {
      'Accept' => 'application/json',
      'Authorization' => 'Basic PDxDTElFTlRfSUQ+Pjo8PENMSUVOVF9TRUNSRVQ+Pg=='
    }.merge(github_base_headers)
  end

  def github_api_headers
    {
      'Accept' => 'application/vnd.github.v3+json',
      'Authorization' => 'token random_token'
    }.merge(github_base_headers)
  end

  def github_base_headers
    {
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/json',
      'User-Agent' => 'Octokit Ruby Gem 5.6.1'
    }
  end
end
