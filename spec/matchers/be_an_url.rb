# frozen_string_literal: true

RSpec::Matchers.define :be_an_url do
  match do |actual|
    actual =~ URI::DEFAULT_PARSER.make_regexp
  end
end
