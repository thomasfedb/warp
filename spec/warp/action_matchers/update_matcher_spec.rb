require "spec_helper"

describe Warp::ActionMatchers::UpdateMatcher do
  let(:model) do
    JamJar.model do
      column :foo, :string

      validates :foo, presence: true
    end
  end

  before { Warp::Instrument.for(model, Warp::ActionMatchers::UpdateMatcher.new(Object.new).send(:instrument_method)).calls << Object.new }

  let(:instance) { model.create(foo: "bar") }

  subject { update(model) }

  with_contexts do
    context "when updated with #update_attributes" do
      let(:block) { -> { instance.update_attributes(params) } }
    end

    context "when updated with #save" do
      let(:block) { -> { instance.foo = params[:foo]; instance.save } }
    end

    behaviour do
      context "with a valid record" do
        let(:params) { {foo: "baz"} }

        specify { expect(subject).to match block }
      end

      context "with an invalid record" do
        let(:params) { {foo: nil} }

        specify { expect(subject).to_not match block }
      end
    end
  end

  context "when nothing is updated" do
    let(:block) { -> { return } }

    specify { expect(subject).to_not match block }
  end

  describe "#desciption" do
    subject { super().description }

    specify { expect(subject).to eq "update a TestModel" }
  end

  describe_failure_message do
    specify { expect(subject).to eq "expected a TestModel to be updated" }
  end

  describe_failure_message_when_negated do
    specify { expect(subject).to eq "expected no TestModel to be updated" }
  end
end
