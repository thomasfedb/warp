require "spec_helper"

describe Warp::ControllerMatchers::AssignMatcher do
  build_controller

  subject { assign(:assign) }

  describe "#description" do
    subject { super().matches?(controller); super().description }

    specify { expect(subject).to eq "assign @assign" }
  end

  context "when assigned" do
    controller_action do
      @assign = Object.new
    end

    specify { expect(subject).to match(controller) }
  
    describe "#failure_message_when_negated" do
      subject { super().matches?(controller); super().failure_message_when_negated }

      specify { expect(subject).to eq "expected @assign to not be assigned" }
    end
  end

  context "when not assigned" do
    controller_action do
      # no assign
    end

    specify { expect(subject).to_not match(controller) }
    
    describe "#failure_message" do
      subject { super().matches?(controller); super().failure_message }

      specify { expect(subject).to eq "expected @assign to be assigned" }
    end
  end

  describe "#with" do
    controller_action do
      @assign = spec.actual_assign_value
    end

    let(:actual_assign_value) { "foobar" }
    let(:expected_assign_value) { "foobar" }

    subject { super().with(expected_assign_value) }

    describe "#description" do
      subject { super().matches?(controller); super().description }

      specify { expect(subject).to eq "assign @assign with #{expected_assign_value.inspect}" }
    end

    context "with the right value" do
      specify { expect(subject).to match(controller) }
    
      describe "#failure_message_when_negated" do
        subject { super().matches?(controller); super().failure_message_when_negated }

        specify { expect(subject).to eq "expected @assign to not be assigned with #{expected_assign_value.inspect}" }
      end
    end

    context "with the wrong value" do
      let(:expected_assign_value) { "foobaz" }

      specify { expect(subject).to_not match(controller) }
      
      describe "#failure_message" do
        subject { super().matches?(controller); super().failure_message }

        specify { expect(subject).to eq "expected @assign to be assigned with #{expected_assign_value.inspect} but was assigned with #{actual_assign_value.inspect}" }
      end
    end
  end

  describe "#with_a" do
    controller_action do
      @assign = spec.actual_assign_class.new
    end

    let(:actual_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "FooClass" } } }
    let(:expected_assign_class) { actual_assign_class }

    subject { assign(:assign).with_a(expected_assign_class) }

    describe "#description" do
      subject { super().matches?(controller); super().description }

      specify { expect(subject).to eq "assign @assign with an instance of #{expected_assign_class.name}" }
    end

    context "with the right class" do
      specify { expect(subject).to match(controller) }
        
      describe "#failure_message_when_negated" do
        subject { super().matches?(controller); super().failure_message_when_negated }

        specify { expect(subject).to eq "expected @assign to not be assigned with an instance of #{expected_assign_class.name}" }
      end
    end

    context "with the wrong class" do
      let(:expected_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "BarClass" } } }

      specify { expect(subject).to_not match(controller) }
      
      describe "#failure_message" do
        subject { super().matches?(controller); super().failure_message }

        specify { expect(subject).to eq "expected @assign to be assigned with an instance of #{expected_assign_class.name} but was assigned with an instance of #{actual_assign_class.name}"
 }
      end
    end
  end

  describe "#with_a_new" do
    controller_action do
      @assign = spec.actual_assign_class.new
    end

    let(:actual_persisted?) { false }
    let(:actual_assign_class) do
      Class.new.tap do |klass| 
        allow(klass).to receive(:name) { "FooClass" }
        allow_any_instance_of(klass).to receive(:persisted?) { actual_persisted? }
      end
    end

    let(:expected_assign_class) { actual_assign_class }

    subject { assign(:assign).with_a_new(expected_assign_class) }

    describe "#description" do
      subject { super().matches?(controller); super().description }

      specify { expect(subject).to eq "assign @assign with a new instance of #{expected_assign_class.name}" }
    end

    context "with a new object" do
      let(:actual_persisted?) { false }

      context "with the right class" do
        specify { expect(subject).to match(controller) }

        describe "#failure_message_when_negated" do
          subject { super().matches?(controller); super().failure_message_when_negated }

          specify { expect(subject).to eq "expected @assign to not be assigned with a new instance of #{expected_assign_class.name}" }
        end
      end

      context "with a descendant class" do
        let(:actual_assign_class) do
          Class.new(super())
        end

        specify { expect(subject).to match(controller) }

        describe "#failure_message_when_negated" do
          subject { super().matches?(controller); super().failure_message_when_negated }

          specify { expect(subject).to eq "expected @assign to not be assigned with a new instance of #{expected_assign_class.name}" }
        end 
      end

      context "with the wrong class" do
        let(:expected_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "BarClass" } } }

        specify { expect(subject).to_not match(controller) }
        
        describe "#failure_message" do
          subject { super().matches?(controller); super().failure_message }

          specify { expect(subject).to eq "expected @assign to be assigned with a new instance of #{expected_assign_class.name} but was assigned with a new instance of #{actual_assign_class.name}"
   }
        end
      end
    end

    context "with a persisted object" do
      let(:actual_persisted?) { true }

      context "with the right class" do
        specify { expect(subject).to_not match(controller) }
        
        describe "#failure_message" do
          subject { super().matches?(controller); super().failure_message }

          specify { expect(subject).to eq "expected @assign to be assigned with a new instance of #{expected_assign_class.name} but was assigned with a persisted instance of #{actual_assign_class.name}"
   }
        end
      end

      context "with the wrong class" do
        let(:expected_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "BarClass" } } }

        specify { expect(subject).to_not match(controller) }
        
        describe "#failure_message" do
          subject { super().matches?(controller); super().failure_message }

          specify { expect(subject).to eq "expected @assign to be assigned with a new instance of #{expected_assign_class.name} but was assigned with a persisted instance of #{actual_assign_class.name}"
   }
        end
      end
    end
  end
end