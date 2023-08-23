# frozen_string_literal: true

require 'rails_helper'

describe 'when user is redirected after github connection' do
  let(:code) { '123456' }

  before do
    Stubber.access_token_stub(code)
    Stubber.github_user_stub({ avatar_url: '', id: '', login: 'john_doe' }.to_json)
    Stubber.github_repo_stub :get, '/branches', Factory.branches_result
    Stubber.github_repo_stub :get, '/git/trees/heads/main?recursive=true', Factory.recursive_tree_result
    Stubber.github_repo_stub :get, '/git/trees/heads/main__translations?recursive=true', Factory.recursive_tree_result
    Stubber.github_sha_or_branch_stub :get, 'main__translations', Array.new(3, {}).to_json
    Stubber.github_repo_stub :get, '', Factory.repository_result
  end

  it 'display homepage' do
    visit "/locale_ninja/github?code=#{code}"
    expect(page).to have_content(I18n.t('components.sidebar.dashboard'))
      .and(have_link(I18n.t('components.sidebar.translations')))
      .and(have_link(I18n.t('components.sidebar.disconnect')))
  end
end
