# frozen_string_literal: true

module LocaleNinja
  module LocaleHelper
    def self.keys2yml(translation_keys)
      files = translation_keys.group_by { |key, _| key.split('$').first }.transform_values(&:to_h)
      files.transform_values! { |translations| translations.transform_keys { |key| key.split('$').last } }
      files.transform_values! do |file|
        file.each_with_object({}) do |(key, value), hash|
          hash.deep_merge!(key.split('.').reverse.reduce(value) { |a, n| { n => a } })
        end.to_yaml
      end
    end

    def self.locales(github_service, branch: 'translations')
      github_service.locale_files_path(branch:).map { |path| path.scan(/\w+(?=\.yml)/).first }.uniq
    end

    def self.locales_count(github_service)
      locales(github_service).count
    end

    def self.all_keys(github_service, branch: 'translations')
      locales_yml = github_service.pull(branch:).transform_values { |file| YAML.load(file) }
      locales_list = locales_yml.values.map(&:keys).flatten.uniq
      locales_yml.flat_map do |path, file|
        path = path.gsub(/\b(#{locales_list.join('|')})\b/, '%<locale>s')
        hash2keys(file.values.first).map { |key| "#{path}$%<locale>s.#{key}" }
      end.uniq
    end

    def self.all_keys_for_locales(github_service, locales, branch: 'translations')
      locales_yml = github_service.pull(branch:).transform_values { |file| YAML.load(file) }
      locales_list = locales_yml.values.map(&:keys).flatten.uniq
      locales_yml.transform_values! { |hash| [hash.keys.first, traverse(hash.values.first).to_h] }
      generic_keys = locales_yml.flat_map do |path, file|
        path = path.gsub(/\b(#{locales_list.join('|')})\b/, '%<locale>s')
        _, hash = file
        hash.map { |key, _hash| "#{path}$%<locale>s.#{key}" }
      end.uniq
      translations = locales_yml.flat_map do |path, (locale, hash)|
        hash.map do |key, value|
          ["#{path}$#{locale}.#{key}", value]
        end
      end.to_h

      locales.map do |locale|
        generic_keys.to_h do |key|
          locale_key = format(key, locale:)
          [locale_key, translations[locale_key]]
        end
      end
    end

    def self.missing_keys(locale, github_service, branch:)
      generic_keys = all_keys(github_service, branch:)
      locale_yml = pull_one_locale(locale, github_service, branch:)
      locale_keys = locale_yml.flat_map do |path, file|
        hash2keys(file).map { |key| "#{path}$#{key}" }
      end.uniq
      generic_keys.map { |key| format(key, locale:) } - locale_keys
    end

    def self.pull_one_locale(locale, github_service, branch: 'translations')
      locale_files_path = github_service.locale_files_path(branch:).filter { |path| path.ends_with?("#{locale}.yml") }
      github_service.pull(locale_files_path, branch:).transform_values { |file| YAML.load(file) }
    end

    def self.traverse(hash, parent_key = nil)
      path = []
      hash.each do |key, value|
        current_key = parent_key ? "#{parent_key}.#{key}" : key.to_s
        if value.is_a?(Hash)
          path.concat(traverse(value, current_key))
        else
          path << [current_key, value]
        end
      end
      path
    end

    def self.hash2keys(hash, parent_key = nil)
      keys = []
      hash.each do |key, value|
        current_key = parent_key ? "#{parent_key}.#{key}" : key.to_s
        if value.is_a?(Hash)
          keys.concat(hash2keys(value, current_key))
        else
          keys << current_key
        end
      end
      keys
    end
  end
end
