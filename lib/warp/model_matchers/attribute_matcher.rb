require "warp/model_matchers/matcher"

module Warp
  module ModelMatchers
    class AttributeMatcher < Warp::ModelMatchers::Matcher
      attr_reader :attr_name

      def initialize(attr_name)
        @attr_name = attr_name.to_sym
      end

      def matches?(model_or_instance)
        @model_or_instance = model_or_instance

        attributes.any? {|actual| values_match?(attr_name, actual) }
      end

      def description
        "have attribute #{description_of(attr_name)}"
      end

      def failure_message
        "expected #{model_name} to #{description}"
      end

      def failure_message_when_negated
        "expected #{model_name} to not #{description}"
      end

      private

      def attributes
        model.attribute_names.map(&:to_sym)
      end
    end

    def have_attribute(attr_name)
      AttributeMatcher.new(attr_name)
    end
  end
end