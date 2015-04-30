require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class DestroyMatcher < Warp::ActionMatchers::Matcher
      def self.instrument_method
        if ActiveRecord::Base.private_method_defined?(:destroy_row)
          :destroy_row
        else
          :destroy
        end
      end

      attr_reader :model

      def initialize(model)
        @model = model
      end

      def description
        "destroy a #{model_name}"
      end

      def failure_message
        "expected a #{model_name} to be destroyed"
      end

      def failure_message_when_negated
        "expected no #{model_name} to be destroyed"
      end
    end

    def destroy(model)
      DestroyMatcher.new(model)
    end
  end
end
