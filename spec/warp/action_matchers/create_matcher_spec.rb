require "spec_helper"

describe Warp::ActionMatchers::CreateMatcher do
  build_model

  subject { create(model) }

  context "when created with #create" do
    let(:block) { -> { model.create({}) } }

    specify { expect(subject).to match block }
  end

  context "when created with #save" do
    let(:block) { -> { model.new.save } }

    specify { expect(subject).to match block }
  end

  context "when nothing created" do
    let(:block) { -> { return } }

    specify { expect(subject).to_not match block }
  end

  describe "#desciption" do
    subject { super().description }

    specify { expect(subject).to eq "create a TestModel" }
  end

  describe_failure_message do
    specify { expect(subject).to eq "expected a TestModel to be created" }
  end

  describe_failure_message_when_negated do
    specify { expect(subject).to eq "expected no TestModel to be created" }
  end
end