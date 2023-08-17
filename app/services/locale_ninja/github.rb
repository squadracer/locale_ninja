# frozen_string_literal: true

module LocaleNinja
  module Github
    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret
    REPOSITORY_FULLNAME = Rails.application.credentials.github.repository_name

    BASE_URL = 'https://github.com'
    BASE_API = 'https://api.github.com'

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET
    private_constant :REPOSITORY_FULLNAME
    private_constant :BASE_URL
    private_constant :BASE_API

    class Client
      def initialize(access_token)
        @instance = Faraday.new(
          url: BASE_API, headers: { 'Accept' => 'application/vnd.github+json' }
        ) do |r|
          r.request(:json)
          r.request(:authorization, 'Bearer', access_token)
          r.response(:json, parser_options: { symbolize_names: true })
          r.response(:logger)
        end
      end

      def user
        @instance.get('/user').body
      end

      def self.get_access_token(code)
        client = Faraday.new do |r|
          r.request(:json)
          r.response(:json)
          r.response(:raise_error)
          r.response(:logger)
        end
        client.post("#{BASE_URL}/login/oauth/access_token", client_id: CLIENT_ID,
                                                            client_secret: CLIENT_SECRET,
                                                            code:
        ).then { |res| CGI.parse(res.body) }
              .slice('access_token', 'refresh_token')
              .transform_values(&:first)
              .symbolize_keys
      end
    end
  end
end
