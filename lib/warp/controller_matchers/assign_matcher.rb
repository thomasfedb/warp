module Warp
  module ControllerMatchers
    class AssignMatcher < Warp::Matcher
      attr_reader :assign_key, :assign_with, :assign_with_a, :assign_with_a_new
      attr_reader :controller, :failure_message, :failure_message_when_negated, :description

      def initialize(assign_key, controller)
        @assign_key = assign_key
        @controller = controller
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
      
      def matches?(actual)
        @controller = actual if actual.is_a?(ActionController::Metal)

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
        @description = "assign @#{assign_key} with #{description_of(assign_with)}"
        @failure_message = "expected @#{assign_key} to be assigned with #{description_of(assign_with)} but was assigned with #{assign_value.inspect}"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned with #{description_of(assign_with)}"

        values_match?(assign_with, assign_value)
      end

      def check_assign_with_a
        @description = "assign @#{assign_key} with an instance of #{assign_with_a.name}"
        @failure_message = "expected @#{assign_key} to be assigned with an instance of #{assign_with_a.name} but was assigned with an instance of #{assign_value.class.name}"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned with an instance of #{assign_with_a.name}"

        has_ancestor?(assign_with_a, assign_value)
      end

      def check_assign_with_a_new
        @description = "assign @#{assign_key} with a new instance of #{assign_with_a_new.name}"
        @failure_message = "expected @#{assign_key} to be assigned with a new instance of #{assign_with_a_new.name} but was assigned with a #{assign_value.persisted? ? "persisted" : "new"} instance of #{assign_value.class.name}"
        @failure_message_when_negated = "expected @#{assign_key} to not be assigned with a new instance of #{assign_with_a_new.name}"

        has_ancestor?(assign_with_a_new, assign_value) && values_match?(false, assign_value.persisted?)
      end

      def assign_value
        controller.view_assigns[assign_key.to_s]
      end

      def multiple_assertions?
        [@assign_with, @assign_with_a, @assign_with_a_new].compact.size > 1
      end

      def has_ancestor?(expected_class, actual)
        actual.class.ancestors.any? {|ancestor| values_match?(expected_class, ancestor) }
      end
    end

    def assign(assign_key)
      AssignMatcher.new(assign_key, controller)
    end
  end
end