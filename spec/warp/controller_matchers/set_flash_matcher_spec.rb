require "spec_helper"

describe Warp::ControllerMatchers::SetFlashMatcher do
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
      let(:flash_key) { [:notice, :error].sample }

      let(:matcher) { set_flash(flash_key) }

      describe "#description" do
        subject { super().description }

        specify { expect(subject).to eq "set flash[:#{flash_key}]" }
      end

      context "with a flash set" do
        let(:actual_flash_value) { Object.new }

        controller_action do
          flash[spec.flash_key] = spec.actual_flash_value
        end

        specify { expect(subject).to match(_controller) }
      
        describe "#failure_message_when_negated" do
          subject { super().failure_message_when_negated }

          specify { expect(subject).to eq "expected flash[:#{flash_key}] to not be set" }
        end
      end

      context "with no flash set" do
        specify { expect(subject).to_not match(_controller) }
      
        describe "#failure_message" do
          subject { super().failure_message }

          specify { expect(subject).to eq "expected flash[:#{flash_key}] to be set" }
        end
      end

      describe "#to" do
        let(:expected_flash_value) { Object.new }

        let(:matcher) { super().to(expected_flash_value) }

        describe "#description" do
          subject { super().description }

          specify { expect(subject).to eq "set flash[:#{flash_key}] to #{expected_flash_value.inspect}" }
        end

        context "with expexted flash value" do
          let(:actual_flash_value) { expected_flash_value }

          controller_action do
            flash[spec.flash_key] = spec.actual_flash_value
          end

          specify { expect(subject).to match(_controller) }
        
          describe "#failure_message_when_negated" do
            subject { super().failure_message_when_negated }

            specify { expect(subject).to eq "expected flash[:#{flash_key}] to not be set to #{expected_flash_value.inspect}" }
          end
        end

        context "with unexpexted flash value" do
          let(:actual_flash_value) { Object.new }

          specify { expect(subject).to_not match(_controller) }
        
          describe "#failure_message" do
            subject { super().failure_message }

            specify { expect(subject).to eq "expected flash[:#{flash_key}] to be set to #{expected_flash_value.inspect}" }
          end
        end
      end
    end
  end
end