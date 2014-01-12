module Warp
  module ModelMatchers
    class ValidationMatcher < Warp::ModelMatchers::Matcher
      VALIDATORS = [
        ActiveModel::Validations::AcceptanceValidator,
        ActiveModel::Validations::ConfirmationValidator,
        ActiveModel::Validations::ExclusionValidator,
        ActiveModel::Validations::FormatValidator,
        ActiveModel::Validations::InclusionValidator,
        ActiveModel::Validations::LengthValidator,
        ActiveModel::Validations::NumericalityValidator,
        ActiveModel::Validations::PresenceValidator
      ]

      # AbsenceValidator added in Rails 4
      if defined?(ActiveModel::Validations::AbsenceValidator)
        VALIDATORS << ActiveModel::Validations::AbsenceValidator
      end

      if defined?(ActiveRecord)
        VALIDATORS.concat [
          ActiveRecord::Validations::AssociatedValidator,
          ActiveRecord::Validations::UniquenessValidator
        ]
      end

      # In Rails 4 PresenceValidator is subclassed by AR
      if defined?(ActiveRecord::Validations::PresenceValidator)
        VALIDATORS.delete(ActiveModel::Validations::PresenceValidator)
        VALIDATORS.push(ActiveRecord::Validations::PresenceValidator)
      end

      VALIDATORS.freeze

      attr_reader :attr_name, :validator_class, :validator_options, :display_options

      def initialize(attr_name, validator_class, validator_options, display_options)
        @attr_name = attr_name
        @validator_class = validator_class
        @validator_options = validator_options
        @display_options = display_options
      end

      def matches?(model_or_instance)
        @model_or_instance = model_or_instance

        validators.any? do |validator|
          if values_match?(validator_class, validator.class)
            validator_options.nil? || values_match?(validator_options, validator.options)
          else
            false
          end
        end
      end

      def failure_message
        "expected #{model_name} to #{description}"
      end

      def failure_message_when_negated
        "expected #{model_name} to not #{description}"
      end

      def description
        str = "have validator #{validator_class.name} on :#{attr_name}"
        str << " with options #{description_of(display_options)}" if display_options.present?
        str
      end

      private

      def validators
        model._validators[attr_name]
      end
    end

    ValidationMatcher::VALIDATORS.each do |validator|
      validator_name = validator.name.match(/::(?<name>\w+)Validator/)[:name].underscore.to_sym
      method_name = (validator_name == :associated) ? "validate_associated" : "validate_#{validator_name}_of"

      define_method method_name do |attr_name, *options|
        display_options = options.first
        options = display_options.try(:dup) || {}

        case validator_name 
        when :uniqueness
          options = {case_sensitive: true}.merge(options)
        when :acceptance
          options = {allow_nil: true, accept: "1"}.merge(options)
        end

        options = nil if options.empty?

        ValidationMatcher.new(attr_name, validator, options, display_options)
      end
    end
  end
end