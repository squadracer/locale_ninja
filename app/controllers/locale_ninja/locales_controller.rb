# frozen_string_literal: true

module LocaleNinja
  require 'json'
  require 'cgi'
  class LocalesController < ApplicationController
    before_action :set_client, only: %i[show update]

    CLIENT_ID = Rails.application.credentials.github.client_id
    CLIENT_SECRET = Rails.application.credentials.github.client_secret

    private_constant :CLIENT_ID
    private_constant :CLIENT_SECRET

    def show
      @locale = params[:locale]
      @branch_name = params[:branch_id]
      @source, @target = LocaleHelper.all_keys_for_locales(@client.pull(branch: @branch_name), [I18n.default_locale.to_s, @locale])
      @translations = @target.zip(@source)
    end

    def update
      @branch_name = params[:branch_id]
      translation_keys = params[:val].permit!.to_h.compact_blank
      yml = LocaleHelper.keys2yml(translation_keys)
      yml.each { |path, file| @client.push(path, file, branch: @branch_name) }
      @client.pull_request(@branch_name)
      flash[:success] = t('.success')

      redirect_to(branch_path(@branch_name))
    end
  end
end
