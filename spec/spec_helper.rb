require "bundler"

unless ENV["TRAVIS_CI"]
  if RUBY_VERSION[0] == "2"
    require "byebug"
  else
    require "debugger"
  end
end

if ENV["TRAVIS_CI"]
  Bundler.require
else
  Bundler.require(:default, :tools)
end

if defined?(Rails) && !Rails.respond_to?(:env)
  module Rails
    def self.env
      "default_env"
    end
  end
end

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f }

RSpec.configure do |config|
  config.order = "random"

  config.extend ControllerHelpers
  config.extend FailureMessageHelpers
  config.extend WithContextsHelpers
  config.include MatchHelpers
end
