unless defined?(ActionController)
  raise RuntimeError, "ActionController is required to use Warp::ControllerMatchers."
end

require "warp/controller_matchers/assign_matcher"
require "warp/controller_matchers/set_flash_matcher"

RSpec.configure do |config|
  config.include Warp::ControllerMatchers
end