# frozen_string_literal: true

require_relative '../../lib/locale_ninja/plateform_container'
LocaleNinja::PlateformContainer.register('git_service') do
  LocaleNinja::GithubApiService.new
end
LocaleNinja::GitService = Dry::AutoInject(LocaleNinja::PlateformContainer)
