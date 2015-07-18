require "spec_helper"

describe Warp::ActionMatchers::DestroyMatcher do
  let(:model) { JamJar.model }

  let!(:instance) { model.create }

  before { Warp::Instrument.for(model, Warp::ActionMatchers::DestroyMatcher.new(Object.new).send(:instrument_method)).calls << Object.new }

  subject { destroy(model) }

  with_contexts do
    context "when destroyed with #destroy" do
      let(:block) { -> { instance.destroy } }
    end

    context "when destroyed with #destroy_all" do
      let(:block) { -> { model.destroy_all } }
    end

    behaviour do
      specify { expect(subject).to match block }
    end
  end

  context "when nothing destroyed" do
    let(:block) { -> { return } }

    specify { expect(subject).to_not match block }
  end

  describe "#desciption" do
    subject { super().description }

    specify { expect(subject).to eq "destroy a TestModel" }
  end

  describe_failure_message do
    specify { expect(subject).to eq "expected a TestModel to be destroyed" }
  end

  describe_failure_message_when_negated do
    specify { expect(subject).to eq "expected no TestModel to be destroyed" }
  end
end
