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
      @branches = @client.public_branch_names
      @branch_name = params[:id]
      locales = LocaleHelper.locales(@client.locale_files_path(branch: @branch_name))
      all_translations = LocaleHelper.all_keys_for_locales(@client.pull(branch: @branch_name), locales)

      @completion_by_locale = locales.zip(all_translations).to_h do |locale, translations|
        [locale, 100 * translations.values.count(&:present?) / translations.count]
      end
    end
  end
end
