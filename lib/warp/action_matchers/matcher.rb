require "warp/matcher"

module Warp
  module ActionMatchers
    class Matcher < Warp::Matcher
      def matches?(actual)
        check_callable!(actual)

        instrument = Warp::Instrument.for(model, self.class.instrument_method)

        instrument.reset
        instrument.run { actual.call }

        instrument.calls.size > 0
      end

      private

      def check_callable!(object)
        unless object.respond_to?(:call)
          raise "#{self.class.name} can only match against callables."
        end
      end

      def model_name
        model.model_name.to_s
      end
    end
  end
end
