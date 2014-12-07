unless defined?(ActiveModel)
  raise RuntimeError, "ActiveModel is required to use Warp::ModelMatchers."
end

# require "warp/model_matchers/error_matcher"
require "warp/model_matchers/validation_matcher"

if defined?(ActiveRecord)
  require "warp/model_matchers/association_matcher"
  require "warp/model_matchers/attribute_matcher"
end

RSpec.configure do |config|
  config.include Warp::ModelMatchers, type: :model
end