# frozen_string_literal: true

module LocaleNinja
  module ApplicationHelper
    def country_flag(locale)
      locale.upcase.codepoints.map { |c| c + (0x1F1E6 - 65) }.pack('U*')
    end
  end
end
