module Warp
  module ModelMatchers
    class Matcher < Warp::Matcher
      private

      def model(model_or_instance)
        if model_or_instance.is_a? Class
          model_or_instance
        else
          model_or_instance.class
        end
      end
    end
  end
end