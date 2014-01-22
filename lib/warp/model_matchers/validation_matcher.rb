module Warp
  module ModelMatchers
    class ValidationMatcher < Warp::ModelMatchers::Matcher
      VALIDATORS = {
        accptance: [ActiveModel::Validations::AcceptanceValidator],
        confirmation: [ActiveModel::Validations::ConfirmationValidator],
        exclusion: [ActiveModel::Validations::ExclusionValidator],
        format: [ActiveModel::Validations::FormatValidator],
        inclusion: [ActiveModel::Validations::InclusionValidator],
        length: [ActiveModel::Validations::LengthValidator],
        numericality: [ActiveModel::Validations::NumericalityValidator],
        presence: [ActiveModel::Validations::PresenceValidator]
      }

      # AbsenceValidator added in Rails 4
      if defined?(ActiveModel::Validations::AbsenceValidator)
        VALIDATORS[:absence] = [ActiveModel::Validations::AbsenceValidator]
      end

      if defined?(ActiveRecord)
        VALIDATORS.merge!({
          associated: [ActiveRecord::Validations::AssociatedValidator],
          uniqueness: [ActiveRecord::Validations::UniquenessValidator]
        })
      end

      # In Rails 4 PresenceValidator is subclassed by AR
      if defined?(ActiveRecord::Validations::PresenceValidator)
        VALIDATORS[:presence] << ActiveRecord::Validations::PresenceValidator
      end

      VALIDATORS.freeze

      attr_reader :attr_name, :validator_classes, :validator_options, :display_options

      def initialize(attr_name, validator_classes, validator_options, display_options)
        @attr_name = attr_name
        @validator_classes = validator_classes
        @validator_options = validator_options
        @display_options = display_options
      end

      def matches?(model_or_instance)
        @model_or_instance = model_or_instance

        validators.any? do |validator|
          if validator_classes.any? {|validator_class| values_match?(validator_class, validator.class) }
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
        str = "have validator #{validator_classes.map(&:name).join(", or ")} on :#{attr_name}"
        str << " with options #{description_of(display_options)}" if display_options.present?
        str
      end

      private

      def validators
        model._validators[attr_name]
      end
    end

    ValidationMatcher::VALIDATORS.each do |validator, validator_classes|
      method_name = (validator == :associated) ? "validate_associated" : "validate_#{validator}_of"

      define_method method_name do |attr_name, *options|
        display_options = options.first
        options = display_options.try(:dup) || {}

        case validator
        when :uniqueness
          options = {case_sensitive: true}.merge(options)
        when :acceptance
          options = {allow_nil: true, accept: "1"}.merge(options)
        end

        options = nil if options.empty?

        ValidationMatcher.new(attr_name, validator_classes, options, display_options)
      end
    end
  end
end