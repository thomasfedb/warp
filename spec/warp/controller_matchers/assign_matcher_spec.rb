require "spec_helper"

describe Warp::ControllerMatchers::AssignMatcher, type: :controller do
  with_contexts do
    context "with implicit controller" do
      build_controller(:controller)
      
      let(:_controller) { controller }

      subject { matcher.tap {|m| m.matches?(Object.new) } }
    end
    
    context "with explicit controller" do
      build_controller(:other_controller)
      let(:controller) { double("fake controller") }

      let(:_controller) { other_controller }

      subject { matcher.tap {|m| m.matches?(other_controller) } }
    end
    
    behaviour do
      let(:matcher) { assign(:assign) }

      describe "#description" do
        subject { super().description }

        specify { expect(subject).to eq "assign @assign" }
      end

      context "when assigned" do
        controller_action do
          @assign = Object.new
        end

        specify { expect(subject).to match(_controller) }
      
        describe_failure_message_when_negated do
          specify { expect(subject).to eq "expected @assign to not be assigned" }
        end
      end

      context "when not assigned" do
        controller_action do
          # no assign
        end

        specify { expect(subject).to_not match(_controller) }
        
        describe_failure_message do
          specify { expect(subject).to eq "expected @assign to be assigned" }
        end
      end

      describe "#with" do
        controller_action do
          @assign = spec.actual_assign_value
        end

        let(:actual_assign_value) { "foobar" }
        let(:expected_assign_value) { "foobar" }

        let(:matcher) { super().with(expected_assign_value) }

        describe "#description" do
          subject { super().description }

          specify { expect(subject).to eq "assign @assign with #{expected_assign_value.inspect}" }
        end

        context "with the right value" do
          specify { expect(subject).to match(_controller) }
        
          describe_failure_message_when_negated do
            specify { expect(subject).to eq "expected @assign to not be assigned with #{expected_assign_value.inspect}" }
          end
        end

        context "with the wrong value" do
          let(:expected_assign_value) { "foobaz" }

          specify { expect(subject).to_not match(_controller) }
          
          describe_failure_message do
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

        let(:matcher) { super().with_a(expected_assign_class) }

        describe "#description" do
          subject { super().description }

          specify { expect(subject).to eq "assign @assign with an instance of #{expected_assign_class.name}" }
        end

        context "with the right class" do
          specify { expect(subject).to match(_controller) }
            
          describe_failure_message_when_negated do
            specify { expect(subject).to eq "expected @assign to not be assigned with an instance of #{expected_assign_class.name}" }
          end
        end

        context "with the wrong class" do
          let(:expected_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "BarClass" } } }

          specify { expect(subject).to_not match(_controller) }
          
          describe_failure_message do
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

        let(:matcher) { super().with_a_new(expected_assign_class) }

        describe "#description" do
          subject { super().description }

          specify { expect(subject).to eq "assign @assign with a new instance of #{expected_assign_class.name}" }
        end

        context "with a new object" do
          let(:actual_persisted?) { false }

          context "with the right class" do
            specify { expect(subject).to match(_controller) }

            describe_failure_message_when_negated do
              specify { expect(subject).to eq "expected @assign to not be assigned with a new instance of #{expected_assign_class.name}" }
            end
          end

          context "with a descendant class" do
            let(:actual_assign_class) do
              Class.new(super())
            end

            specify { expect(subject).to match(_controller) }

            describe_failure_message_when_negated do
              specify { expect(subject).to eq "expected @assign to not be assigned with a new instance of #{expected_assign_class.name}" }
            end 
          end

          context "with the wrong class" do
            let(:expected_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "BarClass" } } }

            specify { expect(subject).to_not match(_controller) }
            
            describe_failure_message do
              specify { expect(subject).to eq "expected @assign to be assigned with a new instance of #{expected_assign_class.name} but was assigned with a new instance of #{actual_assign_class.name}"
       }
            end
          end
        end

        context "with a persisted object" do
          let(:actual_persisted?) { true }

          context "with the right class" do
            specify { expect(subject).to_not match(_controller) }
            
            describe_failure_message do
              specify { expect(subject).to eq "expected @assign to be assigned with a new instance of #{expected_assign_class.name} but was assigned with a persisted instance of #{actual_assign_class.name}"
       }
            end
          end

          context "with the wrong class" do
            let(:expected_assign_class) { Class.new.tap {|klass| allow(klass).to receive(:name) { "BarClass" } } }

            specify { expect(subject).to_not match(_controller) }
            
            describe_failure_message do
              specify { expect(subject).to eq "expected @assign to be assigned with a new instance of #{expected_assign_class.name} but was assigned with a persisted instance of #{actual_assign_class.name}"
       }
            end
          end
        end
      end

      context "multiple assertions" do
        with_contexts do
          context "with .with and .with_a" do
            let(:matcher) { super().with(Object.new).with_a(Class.new) }
          end

          context "with .with_a and .with_a_new" do
            let(:matcher) { super().with_a(Class.new).with_a_new(Class.new) }
          end

          context "with .with_a_new and .with" do
            let(:matcher) { super().with_a_new(Class.new).with(Object.new) }
          end

          context "with .with, .with_a, and .with_a_new" do
            let(:matcher) { super().with(Object.new).with_a(Class.new).with_a_new(Class.new) }
          end

          behaviour do
            specify { expect{ subject }.to raise_error("Only one of .with, .with_a, and .with_a_new can be used with the assigns matcher.") }
          end
        end
      end
    end
  end
end