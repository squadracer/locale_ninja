# frozen_string_literal: true

require 'rails_helper'

LocaleNinja::Configuration
  .const_get(:PLATEFORM_SERVICE_MAP)
  .each_value do |klass|
  describe klass.call do
    include_examples 'git_service', described_class
  end
end
