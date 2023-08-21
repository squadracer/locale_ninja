# frozen_string_literal: true

module LocaleNinja
  TRANSLATIONS_SUFFIX = LocaleNinja.configuration.branch_suffix
  private_constant :TRANSLATIONS_SUFFIX

  class GitBranchName < String
    def translation?
      ends_with?(TRANSLATIONS_SUFFIX)
    end

    def translation
      @translation ||= translation? ? self : GitBranchName.new("#{self}#{TRANSLATIONS_SUFFIX}")
    end

    def base
      @base ||= translation? ? GitBranchName.new(gsub(/#{TRANSLATIONS_SUFFIX}/)) : self
    end
  end
end
