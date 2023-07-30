# frozen_string_literal: true

module LocaleNinja
  module LocaleHelper
    def self.keys2yml(translation_keys)
      translation_keys.each_with_object({}) do |(key, value), hash|
        hash.deep_merge!(key.split('.').reverse.reduce(value) { |a, n| { n => a } })
      end.to_yaml
    end
  end
end
