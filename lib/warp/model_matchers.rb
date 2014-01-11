require "warp/model_matchers/matcher"

require "warp/model_matchers/association_matcher"
require "warp/model_matchers/attribute_matcher"
# require "warp/model_matchers/error_matcher"
# require "warp/model_matchers/validation_matcher"

RSpec.configure do |config|
  config.include Warp::ModelMatchers
end