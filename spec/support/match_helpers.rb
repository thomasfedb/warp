RSpec::Matchers.define :match do |value|
  match do |matcher|
    @matcher = matcher
    matcher.matches?(value)
  end

  description do
    "match #{value}"
  end

  failure_message do
    "expect #{@matcher} to match #{value} but did not"
  end

  failure_message_when_negated do
    "expect #{@matcher} to not match #{value} but did"
  end
end