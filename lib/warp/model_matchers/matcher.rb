require "warp/matcher"

module Warp
  module ModelMatchers
    class Matcher < Warp::Matcher
      attr_reader :model_or_instance

      private

      def model
        if model_or_instance.is_a? Class
          model_or_instance
        else
          model_or_instance.class
        end
      end

      def model_name
        model.name
      end
    end
  end
end