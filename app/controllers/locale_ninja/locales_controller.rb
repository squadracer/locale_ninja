# frozen_string_literal: true

module LocaleNinja
  require 'json'
  require 'cgi'
  class LocalesController < ApplicationController
    before_action :set_service, only: %i[show update]

    CLIENT_ID = LocaleNinja.configuration.client_id
    CLIENT_SECRET = LocaleNinja.configuration.client_secret

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET

    def show
      @locale = params[:locale]
      @branch_name = GitBranchName.new(params[:branch_id])
      @source, @target = all_keys_for_locales(@service.pull(@branch_name), [I18n.default_locale.to_s, @locale])
      @translations = @target.zip(@source)
    end

    def update
      branch_name = GitBranchName.new(params[:branch_id])
      translation_keys = params[:val].permit!.to_h.compact_blank
      yml = keys2yml(translation_keys)
      @service.save(branch_name, yml)

      flash[:success] = t('.success')

      redirect_to(branch_path(branch_name))
    end
  end
end
