require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class CreateMatcher < Warp::ActionMatchers::Matcher
      def self.instrument_method
        if ActiveRecord::Base.private_method_defined?(:_create_record)
          :_create_record
        else
          :create
        end
      end

      attr_reader :model

      def initialize(model)
        @model = model
      end

      def description
        "create a #{model_name}"
      end

      def failure_message
        "expected a #{model_name} to be created"
      end

      def failure_message_when_negated
        "expected no #{model_name} to be created"
      end
    end

    def create(model)
      CreateMatcher.new(model)
    end
  end
end
