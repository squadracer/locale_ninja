# frozen_string_literal: true

require 'rails_helper'

describe 'when user is redirected after github connection' do
  before do
    access_token_stub
    github_user_stub({ avatar_url: '', id: '', login: 'john_doe' }.to_json)
    github_repo_stub(:get, '/branches', branches_result)
    github_repo_stub(:get, '/git/trees/heads/add-locales?recursive=true', recursive_tree_result)
    github_repo_stub(:get, '', repository_result)
  end

  it 'display homepage' do
    visit '/locale_ninja/github?code=123456'
    expect(page).to(have_content('Dashboard'))
    expect(page).to(have_content('@john_doe'))
  end
end
