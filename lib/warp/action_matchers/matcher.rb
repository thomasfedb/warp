require "warp/matcher"

module Warp
  module ActionMatchers
    class Matcher < Warp::Matcher
      private

      def check_callable!(object)
        unless object.respond_to?(:call)
          raise "#{self.class.name} can only match against callables."
        end
      end
    end
  end
end