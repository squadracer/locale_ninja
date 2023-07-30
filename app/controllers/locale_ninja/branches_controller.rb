# frozen_string_literal: true

module LocaleNinja
  class BranchesController < ApplicationController
    before_action :set_client, only: %i[index show]

    def index
      redirect_to(branch_path(@client.default_branch))
    end

    def select
      redirect_to(branch_path(params[:branch_id]))
    end

    def show
      @branches = @client.public_branches
      @branch_name = params[:id]
      locales_yml = @client.pull(branch: @branch_name).values.map { YAML.load(_1) }
      @code_value_by_locales = locales_yml.to_h { [_1.keys[0], LocaleHelper.traverse(_1)] }
    end
  end
end
