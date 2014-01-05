require "warp/controller_matchers/assign_matcher"
require "warp/controller_matchers/set_flash_matcher"

RSpec.configure do |config|
  config.include Warp::ControllerMatchers
end