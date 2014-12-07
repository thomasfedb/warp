require "spec_helper"

describe Warp::Instrument do
  let(:klass) { Class.new }
  let(:method) { :foo }
  let(:instrument) { Warp::Instrument.for(klass, method) }

  before do
    klass.send(:define_method, method) {|*_| return nil }
  end

  describe ".for" do
    subject { instrument }

    context "with no existing instrument" do
      specify { expect(subject).to be_a Warp::Instrument }
      specify { expect(subject).to_not be_enabled }
    end

    context "with an existing instrument" do
      let!(:existing) { subject }

      specify { expect(subject).to equal existing }
    end
  end

  describe "#run" do
    specify { expect{|blk| instrument.run(&blk) }.to yield_control }
  end

  describe "#calls" do
    subject { instrument.calls }

    context "when no calls have been logged" do
      specify { expect(subject).to eq [] }
    end

    context "when a call has been logged" do
      let(:args) { [{baz: :quz}] }

      before do
        instrument.run do
          klass.new.send(method, *args)
        end
      end

      specify { expect(subject).to eq [args] }
    end
  end
end