module Warp
  module ModelMatchers
    class ValidationMatcher < Warp::Matcher
      attr_reader :attr_name, :validator_class, :validator_options

      def initialize(attr_name, validator_class, validator_options)
        @attr_name = attr_name
        @validator_class = validator_class
        @validator_options = validator_options
      end

      def matches? do |model_or_instance|
        @model_or_instance = model_or_instance

        validators.map do |validator|
          values_match?(validator_class, validator.class) && values_match?(validator_options, validator.options)
        end.present?
      end

      def failure_message
        "expected #{model_name} to #{description}"
      end

      def failure_message_when_negated
        "expected #{model_name} to not #{description}"
      end

      def description
        "have validator #{validator_class.name} on #{attr_name} with options #{descripiton_of(validator_options)}"
      end

      private

      def validators(model_instance, attr_name)
        # do stuff
        model_instance._validators[attr_name]
      end
    end

    def validate

    end
  end
end