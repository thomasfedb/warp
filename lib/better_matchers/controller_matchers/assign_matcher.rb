module BetterMatchers
  module ControllerMatchers
    class AssignMatcher
      include RSpec::Matchers::Composable

      attr_reader :assign_key, :assign_with, :assign_with_a, :assign_with_a_new
      attr_reader :controller, :failure_message, :failure_message_when_negated, :description

      def initialize(assign_key)
        @assign_key = assign_key
      end

      def with(assign_eq)
        @assign_with = assign_eq
        self
      end

      def with_a(assign_class)
        @assign_with_a = assign_class
        self
      end

      def with_a_new(assign_class)
        @assign_with_a_new = assign_class
        self
      end
      
      def matches?(controller)
        @controller = controller

        if multiple_assertions?
          raise "Only one of .with, .with_a, and .with_a_new can be used with the assigns matcher."
        end

        return check_assign_with if assign_with
        return check_assign_with_a if assign_with_a
        return check_assign_with_a_new if assign_with_a_new
        return check_assign
      end
      
      private

      def check_assign
        @description = "assign @#{assign_key}"
        @failure_message = "expected @#{assign_key} to be assigned"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned"

        values_match?(false, assign_value.nil?)
      end

      def check_assign_with
        @description = "assign @#{assign_key} with #{assign_with.inspect}"
        @failure_message = "expected @#{assign_key} to be assigned with #{assign_with.inspect} but was assigned with #{assign_value.inspect}"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned with #{assign_with.inspect}"

        values_match?(assign_with, assign_value)
      end

      def check_assign_with_a
        @description = "assign @#{assign_key} with an instance of #{assign_with_a.name}"
        @failure_message = "expected @#{assign_key} to be assigned with an instance of #{assign_with_a.name} but was assigned with an instance of #{assign_value.class.name}"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned with an instance of #{assign_with_a.name}"

        has_ancestor?(assign_value, assign_with_a)
      end

      def check_assign_with_a_new
        @description = "assign @#{assign_key} with a new instance of #{assign_with_a_new.name}"
        @failure_message = "expected @#{assign_key} to be assigned with a new instance of #{assign_with_a_new.name} but was assigned with a #{assign_value.persisted? ? "persisted" : "new"} instance of #{assign_value.class.name}"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned with a new instance of #{assign_with_a_new.name}"

        has_ancestor?(assign_value, assign_with_a_new) && values_match?(false, assign_value.persisted?)
      end

      def assign_value
        controller.view_assigns[assign_key.to_s]
      end

      def multiple_assertions?
        [@assign_with, @assign_with_a, @assign_with_a_new].compact.size > 1
      end

      def has_ancestor?(object, klass)
        object.class.ancestors.any? {|ancestor| values_match?(klass, ancestor) }
      end
    end

    def assign(assign_key)
      AssignMatcher.new(assign_key)
    end
  end
end