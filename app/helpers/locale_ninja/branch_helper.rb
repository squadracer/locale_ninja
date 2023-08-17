# frozen_string_literal: true

module LocaleNinja
  module BranchHelper
    TRANSLATIONS_SUFFIX = '__translations'
    private_constant :TRANSLATIONS_SUFFIX

    def default_branch
      %w[main master].intersection(branch_names).first || branch_names.first
    end

    def branch_to_pull(branch = default_branch)
      translation_branch(branch) if branch?(translation_branch(branch))
    end

    def public_branch_names
      branch_names.reject { |branch| translation_branch?(branch) }
    end

    def translation_branch_names
      branch_names.filter { |branch| translation_branch?(branch) }
    end

    def branch?(branch_name)
      branch_names.include?(branch_name)
    end

    def translation_branch(branch)
      translation_branch?(branch) ? branch : "#{branch}#{TRANSLATIONS_SUFFIX}"
    end

    def translation_branch?(branch_name)
      branch_name.ends_with?(TRANSLATIONS_SUFFIX)
    end

    def branch_names
      session[:branch_names]
    end
  end
end
