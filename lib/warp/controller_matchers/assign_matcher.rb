require "warp/matcher"

module Warp
  module ControllerMatchers
    class AssignMatcherBuilder
      attr_reader :assign_key, :controller

      def initialize(assign_key, controller)
        @assign_key = assign_key
        @controller = controller
      end

      def with(value)
        AssignWithMatcher.new(@controller, @assign_key, value)
      end

      def with_a(klass)
        AssignWithAMatcher.new(@controller, @assign_key, klass)
      end

      def with_a_new(klass)
        AssignWithANewMatcher.new(@controller, @assign_key, klass)
      end

      def method_missing(method, *args)
        matcher.send(method, *args)
      end

      private

      def matcher
        @matcher ||= AssignMatcher.new(@controller, @assign_key)
      end
    end

    def assign(assign_key)
      AssignMatcherBuilder.new(controller, assign_key)
    end

    class AssignMatcher < Warp::Matcher
      attr_reader :assign_key, :controller

      def initialize(assign_key, controller)
        @assign_key = assign_key
        @controller = controller
      end

      def matches?(actual)
        @controller = actual if actual.is_a?(ActionController::Metal)
        check_assign
      end

      def description
        "assign @#{assign_key}"
      end

      def failure_message
        "expected @#{assign_key} to be assigned"
      end

      def failure_message_when_negated
        "expected @#{assign_key} to not be assigned"
      end

      private

      def check_assign
        values_match?(false, assign_value.nil?)
      end

      def assign_value
        controller.view_assigns[assign_key.to_s]
      end
      def has_ancestor?(expected_class, actual)
        actual.class.ancestors.any? {|ancestor| values_match?(expected_class, ancestor) }
      end
    end

    class AssignWithMatcher < AssignMatcher
      attr_reader :assign_with

      def initialize(controller, assign_key, assign_with)
        super(controller, assign_key)
        @assign_with = assign_with
      end

      def description
        "assign @#{assign_key} with #{description_of(assign_with)}"
      end

      def failure_message
        if assign_value.nil?
          "expected @#{assign_key} to be assigned with #{description_of(assign_with)} but was not assigned"
        else
          "expected @#{assign_key} to be assigned with #{description_of(assign_with)} but was assigned with #{assign_value.inspect}"
        end
      end

      def failure_message_when_negated
        "expected @#{assign_key} to not be assigned with #{description_of(assign_with)}"
      end

      private

      def check_assign
        values_match?(assign_with, assign_value)
      end
    end

    class AssignWithAMatcher < AssignMatcher
      attr_reader :assign_with_a

      def initialize(controller, assign_key, assign_with_a)
        super(controller, assign_key)
        @assign_with_a = assign_with_a
      end

      def description
        "assign @#{assign_key} with an instance of #{assign_with_a.name}"
      end

      def failure_message
        if assign_value.nil?
          "expected @#{assign_key} to be assigned with an instance of #{assign_with_a.name} but was not assigned"
        else
          "expected @#{assign_key} to be assigned with an instance of #{assign_with_a.name} but was assigned with an instance of #{assign_value.class.name}"
        end
      end

      def failure_message_when_negated
        "expected @#{assign_key} to not be assigned with an instance of #{assign_with_a.name}"
      end

      private

      def check_assign
        has_ancestor?(assign_with_a, assign_value)
      end
    end

    class AssignWithANewMatcher < AssignMatcher
      attr_reader :assign_with_a_new

      def initialize(controller, assign_key, assign_with_a_new)
        super(controller, assign_key)
        @assign_with_a_new = assign_with_a_new
      end

      def description
        "assign @#{assign_key} with a new instance of #{assign_with_a_new.name}"
      end

      def failure_message
        if assign_value.nil?
          "expected @#{assign_key} to be assigned with a new instance of #{assign_with_a_new.name} but was not assigned"
        else
          "expected @#{assign_key} to be assigned with a new instance of #{assign_with_a_new.name} but was assigned with a #{assign_value.try(:persisted?) ? "persisted" : "new"} instance of #{assign_value.class.name}"
        end
      end

      def failure_message_when_negated
        "expected @#{assign_key} to not be assigned with a new instance of #{assign_with_a_new.name}"
      end

      private

      def check_assign
        has_ancestor?(assign_with_a_new, assign_value) && values_match?(false, assign_value.try(:persisted?))
      end
    end
  end
end
