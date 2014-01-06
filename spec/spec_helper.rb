require 'bundler'

if ENV["TRAVIS_CI"]
  Bundler.require
else
  Bundler.require(:default, :tools)
end

require "active_support/all"
require "action_controller"

require "warp"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f }

RSpec.configure do |config|
  config.order = 'random'

  config.extend ControllerHelpers
  config.extend WithContextsHelpers
end
