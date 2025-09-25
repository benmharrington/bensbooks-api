ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require_relative "./helpers/session_test_helper"
require "rails/test_help"
require "minitest/reporters"
include FactoryBot::Syntax::Methods

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

module ActiveSupport
  class TestCase
    include SessionTestHelper
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
  end
end
