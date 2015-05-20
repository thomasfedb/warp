require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class UpdateMatcher < Warp::ActionMatchers::Matcher
      def self.instrument_method
        if ActiveRecord::Base.private_method_defined?(:_create_record)
          :_update_record
        else
          :update
        end
      end

      attr_reader :model

      def initialize(model)
        @model = model
      end

      def description
        "update a #{model_name}"
      end

      def failure_message
        "expected a #{model_name} to be updated"
      end

      def failure_message_when_negated
        "expected no #{model_name} to be updated"
      end
    end

    def update(model)
      UpdateMatcher.new(model)
    end
  end
end
