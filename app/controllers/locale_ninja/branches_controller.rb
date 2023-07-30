# frozen_string_literal: true

module LocaleNinja
  class BranchesController < ApplicationController
    before_action :set_client, only: %i[index show]

    def index
      @branches = @client.branches
    end

    def select
      redirect_to(branch_path(params[:branch_id]))
    end

    def show
      locales_yml = @client.pull.values.map { YAML.load(_1) }
      @code_value_by_locales = locales_yml.to_h { [_1.keys[0], LocaleHelper.traverse(_1)] }
      @branches = @client.branches
      @branch_name = params[:id]
    end
  end
end
