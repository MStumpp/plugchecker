# frozen_string_literal: true

ENV["RACK_ENV"] = ENV["ENVIRONMENT"] ||= "test"

require "pry"
require "approvals/rspec"
require_relative "../config/environment"
require "timecop"
require "rack/test"

require File.expand_path("../config/environment.rb", __dir__)

RSpec.configure do |config|
  require "factory_bot"
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  require "webmock/rspec"
  WebMock.disable_net_connect!

  Approvals.configure do |c|
    c.approvals_path = "fixtures/approvals/"
  end

  Dir["spec/support/**/*.rb"].each { |f| require f }

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  Approvals.configure do |c|
    c.excluded_json_keys = {
      id: /(\A|_)id$/
    }
  end
end
