# frozen_string_literal: true

LocaleNinja.configure do |config|
  config.plateform = :github
  config.repository = 'organisation/repository'
  config.branch_suffix = '__translations'
  config.client_id = 'Github app CLIENT_ID'
  config.client_secret = 'Github app CLIENT_SECRET'
end
