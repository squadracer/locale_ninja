# frozen_string_literal: true

module LocaleNinja
  class BranchesController < ApplicationController
    def index
      @branches = GithubService.new(access_token:).branches
    end

    def select
      redirect_to(branch_path(params[:branch_id]))
    end

    def show
      locales_yml = LocaleNinja::GithubService.new(access_token:).pull.values.map { YAML.load(_1) }
      @code_value_by_locales = locales_yml.to_h { [_1.keys[0], LocaleHelper.traverse(_1)] }
      @branches = LocaleNinja::GithubService.new(access_token:).branches
      @branch_name = params[:id]
    end
  end
end
