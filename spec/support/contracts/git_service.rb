# frozen_string_literal: true

require 'octokit'

RSpec.shared_examples 'git_service' do |git_service|
  subject { git_service.new(opts) }

  context 'when user is authenfied' do
    let(:opts) do
      { access_token: 'random_token' }
    end

    before do
      Stubber.github_repo_stub :get, '', Factory.repository_result
      Stubber.github_repo_stub :get, '/branches', Factory.branches_result
      Stubber.github_sha_or_branch_stub :get, 'main__translations', Array.new(3, {}).to_json
      Stubber.github_repo_stub :get, '/git/trees/heads/main__translations?recursive=true', Factory.recursive_tree_result
    end

    describe '.connection_url' do
      it 'redirect to service connection url' do
        client_id = LocaleNinja.configuration.client_id
        expect(git_service.connection_url).to be_an_url.and(eq("https://github.com/login/oauth/authorize?&client_id=#{client_id}"))
      end
    end

    describe '#repo_information' do
      let(:response) do
        {
          full_name: be_an_instance_of(String),
          html_url: be_an_url
        }
      end

      it 'returns informations' do
        expect(subject.repo_information).to include(response)
      end
    end

    describe '#default_branch' do
      it 'returns the configuration default branch' do
        expect(subject.default_branch).to be_an_instance_of(LocaleNinja::GitBranchName).and(eq(LocaleNinja.configuration.default_branch))
      end
    end

    describe '#displayable_branch_names' do
      it 'returns non suffixed branches' do
        expect(subject.displayable_branch_names).to be_an(Array).and(have(2).things)
      end
    end

    describe '#translation_commits_count' do
      it 'return suffixed branches' do
        expect(subject.translation_commits_count).to eq(3)
      end
    end

    describe '#locale_files_path' do
      it 'returns locales file path' do
        expect(subject.locale_files_path).to be_an(Array).and(have(2).things)
      end
    end

    context 'when user is non-authenfied' do
      let(:code) { '' }
      let(:opts) do
        { code: }
      end

      before do
        Stubber.access_token_stub(code)
      end

      describe '#code_for_token' do
        it 'returns access token' do
          expect(subject.code_for_token(code)).to be_a(String).and(eq('random_token'))
        end
      end
    end
  end
end
