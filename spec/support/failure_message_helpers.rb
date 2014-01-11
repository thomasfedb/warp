module FailureMessageHelpers
  if RSpec::Version::STRING[0] == "3"
    FAILURE_MESSAGE_METHOD = :failure_message
    FAILURE_MESSAGE_WHEN_NEGATED_METHOD = :failure_message_when_negated
  else
    FAILURE_MESSAGE_METHOD = :failure_message_for_should
    FAILURE_MESSAGE_WHEN_NEGATED_METHOD = :failure_message_for_should_not
  end

  def describe_failure_message(&blk)
    describe "##{FAILURE_MESSAGE_METHOD}" do
      subject { super().send(FAILURE_MESSAGE_METHOD) }
      instance_eval(&blk)
    end
  end

  def describe_failure_message_when_negated(&blk)
    describe "##{FAILURE_MESSAGE_WHEN_NEGATED_METHOD}" do
      subject { super().send(FAILURE_MESSAGE_WHEN_NEGATED_METHOD) }
      instance_eval(&blk)
    end
  end
end