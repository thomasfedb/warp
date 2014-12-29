require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class DestroyMatcher < Warp::ActionMatchers::Matcher
      if ActiveRecord::Base.private_method_defined?(:destroy_row)
        DESTROY_METHOD = :destroy_row
      else
        DESTROY_METHOD = :destroy
      end

      attr_reader :model

      def initialize(model)
        @model = model
      end

      def matches?(actual)
        check_callable!(actual)

        instrument = Warp::Instrument.for(model, DESTROY_METHOD)

        instrument.reset
        instrument.run { actual.call }

        instrument.calls.size > 0
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