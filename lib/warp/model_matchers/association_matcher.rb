require "warp/model_matchers/matcher"

module Warp
  module ModelMatchers
    class AssociationMatcher < Warp::ModelMatchers::Matcher
      attr_reader :expected_macro, :key
      
      def initialize(expected_macro, key)
        @expected_macro = expected_macro
        @key = key
      end

      def matches?(model_or_instance)
        @model_or_instance = model_or_instance

        association && values_match?(expected_macro, assocation_macro)
      end

      def description
        "have a #{expected_macro} association with :#{key}"
      end

      def failure_message
        if association
          "expected #{model_name} to #{description}, but had a #{assocation_macro} association with :#{key}"
        else
          "expected #{model_name} to #{description}"
        end
      end

      def failure_message_when_negated
        "expected #{model_name} to not #{description}"
      end

      private

      def association
        model.reflect_on_association(key)
      end

      def assocation_macro
        association.macro
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