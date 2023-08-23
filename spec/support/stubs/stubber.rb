# frozen_string_literal: true

require 'webmock/rspec'
module Stubber
  GITHUB_API_URL = 'https://api.github.com'
  REPOSITORY_FULLNAME = LocaleNinja.configuration.repository

  private_constant :GITHUB_API_URL
  private_constant :REPOSITORY_FULLNAME
  class << self
    def access_token_stub(code)
      stub_request(
        [:post, 'https://github.com/login/oauth/access_token'],
        {
          body: "{\"code\":\"#{code}\",\"client_id\":\"<<CLIENT_ID>>\",\"client_secret\":\"<<CLIENT_SECRET>>\"}",
          headers: github_web_headers
        },
        { status: 200, body: { access_token: 'random_token', refresh_token: 'random_refresh_token' }.to_json, headers: { 'Content-Type' => 'application/json' } }
      )
    end

    def github_repo_stub(method, host, body = '')
      stub_request(
        [method, "#{GITHUB_API_URL}/repos/#{REPOSITORY_FULLNAME}#{host}"],
        { headers: github_api_headers },
        { status: 200, body:, headers: { 'Content-Type' => 'application/json' } }
      )
    end

    def github_sha_or_branch_stub(method, host, body = '')
      stub_request(
        [method, "#{GITHUB_API_URL}/repos/#{REPOSITORY_FULLNAME}/commits?sha_or_branch%5Bbranch%5D=#{host}&since=#{1.month.ago.strftime('%Y-%m-%d')}T00:00:00%2B00:00"],
        { headers: github_api_headers },
        { status: 200, body:, headers: { 'Content-Type' => 'application/json' } }
      )
    end

    def github_user_stub(body = '')
      stub_request(
        [:get, "#{GITHUB_API_URL}/user"],
        { headers: github_api_headers },
        { status: 200, body:, headers: { 'Content-Type' => 'application/json' } }
      )
    end

    private

    def stub_request(params, with, result)
      ::WebMock::API.stub_request(*params).with(**with).to_return(**result)
    end

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
end
