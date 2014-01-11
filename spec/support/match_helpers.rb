module MatchHelpers
  class MatchMatcher
    attr_reader :value, :matcher

    def initialize(value)
      @value = value
    end

    def matches?(matcher)
      @matcher = matcher
      matcher.matches?(value)
    end

    def description
      "match #{value}"
    end

    def failure_message
      "expect #{matcher} to match #{value} but did not"
    end

    def failure_message_when_negated
      "expect #{matcher} to not match #{value} but did"
    end
  end

  def match(value)
    MatchMatcher.new(value)
  end
end