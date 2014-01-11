require "spec_helper"

describe Warp::ModelMatchers::AttributeMatcher do
  build_model do
    column :foo
  end

  with_contexts do
    context "with model" do
      let(:model_or_instance) { model }
    end

    context "with model instance" do
      let(:model_or_instance) { model.new }
    end

    behaviour do
      let(:matcher) { have_attribute(attr_name) }

      subject { matcher.tap {|m| m.matches?(model_or_instance) } }

      context "and the attribute exists" do
        let(:attr_name) { :foo }

        specify { expect(subject).to match(model_or_instance) }
      
        describe_failure_message_when_negated do
          specify { expect(subject).to eq "expected to not have attribute :#{attr_name}" }
        end
      end

      context "and the attribute does not exist" do
        let(:attr_name) { :bar }

        specify { expect(subject).to_not match(model_or_instance) }
      
        describe_failure_message do
          specify { expect(subject).to eq "expected to have attribute :#{attr_name}" }
        end
      end
    end
  end
end
