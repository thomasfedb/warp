require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class CreateMatcher < Warp::ActionMatchers::Matcher
      def description
        "create a #{model_name}"
      end

      def failure_message
        "expected a #{model_name} to be created"
      end

      def failure_message_when_negated
        "expected no #{model_name} to be created"
      end

      private

      def instrument_method
        ActiveRecord::Base.private_method_defined?(:_create_record) ? :_create_record : :create
      end
    end

    def create(model)
      CreateMatcher.new(model)
    end
  end
end
