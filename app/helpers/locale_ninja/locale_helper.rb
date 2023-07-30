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
  end
end
