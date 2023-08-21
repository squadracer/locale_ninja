# frozen_string_literal: true

require 'rails_helper'

describe 'when user is redirected after github connection' do
  let(:code) { '123456' }

  before do
    access_token_stub(code)
    github_user_stub({ avatar_url: '', id: '', login: 'john_doe' }.to_json)
    github_repo_stub :get, '/branches', branches_result
    github_repo_stub :get, '/git/trees/heads/add-locales?recursive=true', recursive_tree_result
    github_repo_stub :get, '', repository_result
  end

  it 'display homepage' do
    visit "/locale_ninja/github?code=#{code}"
    expect(page).to have_content(I18n.t('components.sidebar.dashboard'))
      .and(have_link(I18n.t('components.sidebar.translations')))
      .and(have_link(I18n.t('components.sidebar.disconnect')))
  end
end
