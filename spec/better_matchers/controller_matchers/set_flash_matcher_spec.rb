require "spec_helper"

describe BetterMatchers::ControllerMatchers::SetFlashMatcher do
  build_controller

  let(:flash_key) { [:notice, :error].sample }

  subject { set_flash(flash_key) }

  describe "#description" do
    subject { super().matches?(controller); super().description }

    specify { expect(subject).to eq "set flash[:#{flash_key}]" }
  end

  context "with a flash set" do
    let(:actual_flash_value) { Object.new }

    controller_action do
      flash[spec.flash_key] = spec.actual_flash_value
    end

    specify { expect(subject).to match(controller) }
  
    describe "#failure_message_when_negated" do
      subject { super().matches?(controller); super().failure_message_when_negated }

      specify { expect(subject).to eq "expected flash[:#{flash_key}] to not be set" }
    end
  end

  context "with no flash set" do
    specify { expect(subject).to_not match(controller) }
  
    describe "#failure_message" do
      subject { super().matches?(controller); super().failure_message }

      specify { expect(subject).to eq "expected flash[:#{flash_key}] to be set" }
    end
  end

  describe "#to" do
    let(:expected_flash_value) { Object.new }

    subject { set_flash(flash_key).to(expected_flash_value) }

    describe "#description" do
      subject { super().matches?(controller); super().description }

      specify { expect(subject).to eq "set flash[:#{flash_key}] to #{expected_flash_value.inspect}" }
    end

    context "with expexted flash value" do
      let(:actual_flash_value) { expected_flash_value }

      controller_action do
        flash[spec.flash_key] = spec.actual_flash_value
      end

      specify { expect(subject).to match(controller) }
    
      describe "#failure_message_when_negated" do
        subject { super().matches?(controller); super().failure_message_when_negated }

        specify { expect(subject).to eq "expected flash[:#{flash_key}] to not be set to #{expected_flash_value.inspect}" }
      end
    end

    context "with unexpexted flash value" do
      let(:actual_flash_value) { Object.new }

      specify { expect(subject).to_not match(controller) }
    
      describe "#failure_message" do
        subject { super().matches?(controller); super().failure_message }

        specify { expect(subject).to eq "expected flash[:#{flash_key}] to be set to #{expected_flash_value.inspect}" }
      end
    end
  end
end