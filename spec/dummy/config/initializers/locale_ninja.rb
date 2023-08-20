# frozen_string_literal: true

LocaleNinja.configure do |config|
  config.plateform = :github
  config.repository = 'squadracer/locale-ninja-test'
  config.client_id = Rails.application.credentials.github.client_id
  config.client_secret = Rails.application.credentials.github.client_secret
end
