require "better_matchers/controller_matchers/assign_matcher"
require "better_matchers/controller_matchers/set_flash_matcher"

RSpec.configure do |config|
  config.include BetterMatchers::ControllerMatchers
end