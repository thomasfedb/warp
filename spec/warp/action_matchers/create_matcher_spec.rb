require "spec_helper"

describe Warp::ActionMatchers::CreateMatcher do
  build_model do
    column :foo

    validates :foo, presence: true
  end

  before { Warp::Instrument.for(model, Warp::ActionMatchers::CreateMatcher::CREATE_METHOD).calls << Object.new }

  subject { create(model) }

  with_contexts do
    context "when created with #create" do
      let(:block) { -> { model.create(params) } }
    end

    context "when created with #save" do
      let(:block) { -> { model.new(params).save } }
    end

    behaviour do
      context "with a valid record" do
        let(:params) { {foo: "bar"} } 

        specify { expect(subject).to match block }
      end

      context "with an invalid record" do
        let(:params) { {} }
        
        specify { expect(subject).to_not match block }
      end
    end
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