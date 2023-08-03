# frozen_string_literal: true

module LocaleNinja
  module GithubClient
    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret
    BASE_URL = 'https://github.com'
    BASE_API = 'https://api.github.com'

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET
    private_constant :BASE_URL
    private_constant :BASE_API

    class Secure
      def initialize(access_token)
        @instance = Faraday.new(
          url: BASE_API
        ) do |r|
          r.request(:json)
          r.request(:authorization, 'Bearer', access_token)
          r.response(:json)
          r.response(:logger)
        end
      end

      def user
        res = @instance.get('/user') do |r|
          r.headers['Accept'] = 'application/vnd.github+json'
        end
        res.body.symbolize_keys
      end
    end

    class Insecure
      def initialize
        @instance = Faraday.new(
          url: BASE_URL
        ) do |r|
          r.request(:json)
          r.response(:json)
          r.response(:raise_error)
          r.response(:logger)
        end
      end

      def get_access_token(code)
        res = @instance.post('/login/oauth/access_token') do |r|
          r.body = {
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            code:
          }
        end
        CGI.parse(res.body).slice('access_token', 'refresh_token')
           .transform_values(&:first)
           .symbolize_keys
      end
    end
  end
end
