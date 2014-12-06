require "rspec"

module Warp
  class Matcher
    # Composable matchers are new in RSpec 3.
    # Define basic helpers in their absence.
    if defined?(RSpec::Matchers::Composable)
      include RSpec::Matchers::Composable
    else
      def description_of(object)
        object.inspect
      end

      def values_match?(expected, actual)
        expected === actual || actual == expected
      end
    end

    # RSpec 2 and 3 have different methods
    # that they call on matcher to get the
    # failure messages.
    if RSpec::Version::STRING[0] == "2" || RSpec::Version::STRING == "3.0.0.beta1"
      def failure_message_for_should
        failure_message
      end

      def failure_message_for_should_not
        failure_message_when_negated
      end
    end
  end
end