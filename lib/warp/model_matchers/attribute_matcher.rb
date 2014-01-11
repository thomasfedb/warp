module Warp
  module ModelMatchers
    class AttributeMatcher < Warp::ModelMatchers::Matcher
      attr_reader :attr_name
      attr_reader :failure_message, :failure_message_when_negated, :description

      def initialize(attr_name)
        @attr_name = attr_name.to_sym
      end

      def matches?(model_or_instance)
        if attributes(model_or_instance).any? {|actual| values_match?(attr_name, actual) }
          @failure_message = "expected to have attribute #{description_of(attr_name)}"
          @failure_message_when_negated = "expected to not have attribute #{description_of(attr_name)}"
          true
        else
          @failure_message = "expected to have attribute #{description_of(attr_name)}"
          @failure_message_when_negated = "expected to not have attribute #{description_of(attr_name)}"
          false
        end
      end

      def attributes(model_or_instance)
        model(model_or_instance).column_names.map(&:to_sym)
      end
    end

    def have_attribute(attr_name)
      AttributeMatcher.new(attr_name)
    end
  end
end