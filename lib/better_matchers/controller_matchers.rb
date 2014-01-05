require "better_matchers/controller_matchers/assign_matcher"

RSpec.configure do |config|
  config.include BetterMatchers::ControllerMatchers
end