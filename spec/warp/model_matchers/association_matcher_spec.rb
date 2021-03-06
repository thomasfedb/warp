require "spec_helper"

describe Warp::ModelMatchers::AssociationMatcher, type: :model do
  let(:model) do
    JamJar.model do
      belongs_to :foo
      has_many :bars
      has_one :baz
      has_and_belongs_to_many :qux
    end
  end

  with_contexts do
    context "with model" do
      let(:model_or_instance) { model }
    end

    context "with model instance" do
      let(:model_or_instance) { model.new }
    end

    behaviour do
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

        describe "#have_and_belong_to_many" do
          let(:matcher) { have_and_belong_to_many(key) }

          let(:matcher_macro) { :has_and_belongs_to_many }
          let(:association_key) { :qux }
          let(:wrong_association_key) { :foo }
        end

        behaviour do
          subject { matcher.tap {|m| m.matches?(model_or_instance) } }

          context "when an association exists" do
            context "and the association macro matches" do
              let(:key) { association_key }

              specify { expect(subject).to match(model_or_instance) }

              describe_failure_message_when_negated do
                specify { expect(subject).to eq "expected TestModel to not have a #{matcher_macro} association with :#{key}" }
              end
            end

            context "and the association macro doesn't match" do
              let(:key) { wrong_association_key }
              let(:actual_macro) { model.reflect_on_association(key).macro }

              specify { expect(subject).to_not match(model_or_instance) }

              describe_failure_message do
                specify { expect(subject).to eq "expected TestModel to have a #{matcher_macro} association with :#{key}, but had a #{actual_macro} association with :#{key}" }
              end
            end
          end

          context "when an association doesn't exists" do
            let(:key) { no_association_key }

            specify { expect(subject).to_not match(model_or_instance) }

            describe_failure_message do
              specify { expect(subject).to eq "expected TestModel to have a #{matcher_macro} association with :#{key}" }
            end
          end
        end
      end
    end
  end
end
