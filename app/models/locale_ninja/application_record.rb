# frozen_string_literal: true

module LocaleNinja
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
