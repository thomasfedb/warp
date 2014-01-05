module Warp
  module ControllerMatchers
    class SetFlashMatcher
      include RSpec::Matchers::Composable

      attr_reader :flash_key, :expected_flash_value
      attr_reader :controller, :failure_message, :failure_message_when_negated, :description

      def initialize(flash_key)
        @flash_key = flash_key
      end

      def to(expected_flash_value)
        @expected_flash_value = expected_flash_value
        self
      end

      def matches?(controller)
        @controller = controller

        if expected_flash_value
          @description = "set flash[:#{flash_key}] to #{expected_flash_value.inspect}"
          @failure_message = "expected flash[:#{flash_key}] to be set to #{expected_flash_value.inspect}"
          @failure_message_when_negated = "expected flash[:#{flash_key}] to not be set to #{expected_flash_value.inspect}"
          values_match?(expected_flash_value, flash_value)
        else
          @description = "set flash[:#{flash_key}]"
          @failure_message = "expected flash[:#{flash_key}] to be set"
          @failure_message_when_negated = "expected flash[:#{flash_key}] to not be set"
          values_match?(false, flash_value.nil?)
        end
      end

      private

      def flash_value
        flash[flash_key]
      end

      def flash
        controller.flash
      end
    end

    def set_flash(flash_key)
      SetFlashMatcher.new(flash_key)
    end
  end
end