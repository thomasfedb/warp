module Warp
  module ModelMatchers
    class AssociationMatcher < Warp::Matcher
      attr_reader :macro, :key
      attr_reader :failure_message, :failure_message_when_negated, :description

      def initialize(macro, key)
        @macro = macro
        @key = key
      end

      def matches?(model_or_instance)
        if association = model(model_or_instance).reflect_on_association(key)
          actual_macro = association.macro
          @failure_message = "expected to have association #{macro} :#{key}, but had #{actual_macro} :#{key}"
          @failure_message_when_negated = "expected to not have association #{macro} :#{key}"
          actual_macro == macro
        else
          @failure_message = "expected to have association #{macro} :#{key}"
          @failure_message_when_negated = "expected to not have association #{macro} :#{key}"
          false
        end
      end

      private

      def model(model_or_instance)
        if model_or_instance.is_a? Class
          model_or_instance
        else
          model_or_instance.class
        end
      end

    end

    def have_many(key)
      AssociationMatcher.new(:has_many, key)
    end

    def have_one(key)
      AssociationMatcher.new(:has_one, key)
    end

    def belong_to(key)
      AssociationMatcher.new(:belongs_to, key)
    end

    def have_and_belong_to_many(key)
      if ActiveRecord::VERSION::STRING[0] == "4" && ActiveRecord::VERSION::STRING[3] != "0"
        raise NotImplementedError, "In Rail 4.1+ the has_and_belongs_to_many helper produces a has_many :through association."
      else
        AssociationMatcher.new(:has_and_belongs_to_many, key)
      end
    end
  end
end