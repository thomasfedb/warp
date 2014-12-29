unless defined?(ActiveModel)
  raise RuntimeError, "ActiveModel is required to use Warp::ActionMatchers."
end

require "warp/action_matchers/create_matcher"
require "warp/action_matchers/destroy_matcher"

RSpec.configure do |config|
  config.include Warp::ActionMatchers
end