require 'byebug'
require 'pry'
require 'rails-controller-testing'
require 'active_job'

RSpec.configure do |config|
  ConeyIsland.run_inline if defined? ConeyIsland

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.include ActiveJob::TestHelper

end

ActiveJob::Base.queue_adapter = :test
