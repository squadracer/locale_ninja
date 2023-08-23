# frozen_string_literal: true

LocaleNinja.configure do |config|
  config.plateform = :github
  config.repository = 'organisation/repository'
  config.default_branch = 'main'
  config.branch_suffix = '__translations'
  config.client_id = '<<CLIENT_ID>>'
  config.client_secret = '<<CLIENT_SECRET>>'
end
