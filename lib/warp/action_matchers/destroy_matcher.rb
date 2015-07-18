require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class DestroyMatcher < Warp::ActionMatchers::Matcher
      def description
        "destroy a #{model_name}"
      end

      def failure_message
        "expected a #{model_name} to be destroyed"
      end

      def failure_message_when_negated
        "expected no #{model_name} to be destroyed"
      end

      private

      def instrument_method
        ActiveRecord::Base.private_method_defined?(:destroy_row) ? :destroy_row : :destroy
      end
    end

    def destroy(model)
      DestroyMatcher.new(model)
    end
  end
end
