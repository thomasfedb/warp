require "spec_helper"

describe Warp::ModelMatchers::AssociationMatcher do
  build_model do
    belongs_to :foo
    has_many :bars
    has_one :baz
    has_and_belongs_to_many :qux
  end

  with_contexts do
    context "with model" do
      let(:model_or_instance) { model }
    end

    context "with model instance" do
      let(:model_or_instance) { model.new }
    end

    behaviour do
      if ActiveRecord::VERSION::STRING[0] == "4" && ActiveRecord::VERSION::STRING[3] != "0"
        specify { expect{ have_and_belong_to_many(:foo) }.to raise_error(NotImplementedError) }
      end

      with_contexts do
        let(:no_association_key) { :foobar }

        describe "#have_many" do
          let(:matcher) { have_many(key) }
          
          let(:matcher_macro) { :has_many }
          let(:association_key) { :bars }
          let(:wrong_association_key) { :foo }
        end

        describe "#have_one" do
          let(:matcher) { have_one(key) }
          
          let(:matcher_macro) { :has_one }
          let(:association_key) { :baz }
          let(:wrong_association_key) { :foo }
        end

        describe "#belong_to" do
          let(:matcher) { belong_to(key) }
          
          let(:matcher_macro) { :belongs_to }
          let(:association_key) { :foo }
          let(:wrong_association_key) { :bars }
        end

        
        unless ActiveRecord::VERSION::STRING[0] == "4" && ActiveRecord::VERSION::STRING[3] != "0"
          describe "#have_and_belong_to_many" do
            let(:matcher) { have_and_belong_to_many(key) }
            
            let(:matcher_macro) { :has_and_belongs_to_many }
            let(:association_key) { :qux }
            let(:wrong_association_key) { :foo }
          end
        end

        behaviour do
          subject { matcher.tap {|m| m.matches?(model_or_instance) } }

          context "when an association exists" do
            context "and the association macro matches" do
              let(:key) { association_key }

              specify { expect(subject).to match(model_or_instance) }
            
              describe "#failure_message_when_negated" do
                subject { super().failure_message_when_negated }

                specify { expect(subject).to eq "expected to not have association #{matcher_macro} :#{key}" }
              end
            end

            context "and the association macro doesn't match" do
              let(:key) { wrong_association_key }
              let(:actual_macro) { model.reflect_on_association(key).macro }

              specify { expect(subject).to_not match(model_or_instance) }
            
              describe "#failure_message" do
                subject { super().failure_message }

                specify { expect(subject).to eq "expected to have association #{matcher_macro} :#{key}, but had #{actual_macro} :#{key}" }
              end
            end
          end

          context "when an association doesn't exists" do
            let(:key) { no_association_key }

            specify { expect(subject).to_not match(model_or_instance) }
          
            describe "#failure_message" do
              subject { super().failure_message }

              specify { expect(subject).to eq "expected to have association #{matcher_macro} :#{key}" }
            end
          end
        end
      end
    end
  end
end