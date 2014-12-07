require "warp/action_matchers/matcher"
require "warp/instrument"

module Warp
  module ActionMatchers
    class CreateMatcher < Warp::ActionMatchers::Matcher
      if ActiveRecord::Base.private_method_defined?(:_create_record)
        CREATE_METHOD = :_create_record
      else
        CREATE_METHOD = :create
      end

      attr_reader :model

      def initialize(model)
        @model = model
      end

      def matches?(actual)
        unless actual.respond_to?(:call)
          raise "The create matcher can only match against callables."
        end

        instrument = Warp::Instrument.for(model, CREATE_METHOD)

        instrument.run { actual.call }

        instrument.calls.size > 0
      end

      def description
        "create a #{model.name}"
      end

      def failure_message
        "expected a #{model.name} to be created"
      end

      def failure_message_when_negated
        "expected no #{model.name} to be created"
      end
    end

    def create(model)
      CreateMatcher.new(model)
    end
  end
end