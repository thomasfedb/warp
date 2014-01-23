require "spec_helper"

describe Warp::ModelMatchers::ValidationMatcher do
  build_model do
    column :foo
  end

  let(:attr_name) { :foo }

  let(:matcher) { send(matcher_method, attr_name) }
  let(:matcher_with_options) { send(matcher_method, attr_name, matcher_options) }

  let(:validator_names) { matcher.validator_classes.map(&:name).join(", or ") }

  with_contexts do
    context "with model" do
      let(:model_or_instance) { model }
    end

    context "with model instance" do
      let(:model_or_instance) { model.new }
    end

    behaviour do
      with_contexts do
        # AbsenceValidator added in Rails 4
        if defined?(ActiveModel::Validations::AbsenceValidator)
          context "#validate_absence_of" do
            let(:matcher_method) { :validate_absence_of }
            let(:matcher_options) { {message: "must be blank"} }
            let(:validation_method) { :validates_absence_of }
            let(:validation_base_options) { {} }
          end
        end

        context "#validate_acceptance_of" do
          let(:matcher_method) { :validate_acceptance_of }
          let(:matcher_options) { {if: :enabled?} }
          let(:validation_method) { :validates_acceptance_of }
          let(:validation_base_options) { {} }
        end

        context "#validate_confirmation_of" do
          let(:matcher_method) { :validate_confirmation_of }
          let(:matcher_options) { {unless: :tuesday?} }
          let(:validation_method) { :validates_confirmation_of }
          let(:validation_base_options) { {} }
        end

        context "#validate_exclusion_of" do
          let(:matcher_method) { :validate_exclusion_of }
          let(:matcher_options) { {in: 12..500} }
          let(:validation_method) { :validates_exclusion_of }
          let(:validation_base_options) { {in: [12, 500]} }
        end

        context "#validate_format_of" do
          let(:matcher_method) { :validate_format_of }
          let(:matcher_options) { {with: /foo[bar]*/} }
          let(:validation_method) { :validates_format_of }
          let(:validation_base_options) { {with: /qu+x/} }
        end

        context "#validate_inclusion_of" do
          let(:matcher_method) { :validate_inclusion_of }
          let(:matcher_options) { {in: ["foo", "bar", "baz", "qux"]} }
          let(:validation_method) { :validates_inclusion_of }
          let(:validation_base_options) { {in: 1..10} }
        end

        context "#validate_length_of" do
          let(:matcher_method) { :validate_length_of }
          let(:matcher_options) { {maximum: 32} }
          let(:validation_method) { :validates_length_of }
          let(:validation_base_options) { {is: 32} }
        end

        context "#validate_numericality_of" do
          let(:matcher_method) { :validate_numericality_of }
          let(:matcher_options) { {even: true} }
          let(:validation_method) { :validates_numericality_of }
          let(:validation_base_options) { {} }
        end

        context "#validate_presence_of" do
          let(:matcher_method) { :validate_presence_of }
          let(:matcher_options) { {unless: :not_required} }
          let(:validation_method) { :validates_presence_of }
          let(:validation_base_options) { {} }
        end

        context "#validate_association_of" do
          let(:matcher_method) { :validate_associated }
          let(:matcher_options) { {message: "it's neither here nor there"} }
          let(:validation_method) { :validates_associated }
          let(:validation_base_options) { {} }
        end

        context "#validate_uniqueness_of" do
          let(:matcher_method) { :validate_uniqueness_of }
          let(:matcher_options) { {scope: :post_id} }
          let(:validation_method) { :validates_uniqueness_of }
          let(:validation_base_options) { {} }
        end

        behaviour do
          context "when matching without options" do
            subject { matcher.tap {|m| m.matches?(model_or_instance) } }

            context "with no matching validation" do
              specify { expect(subject).to_not match(model_or_instance) }

              describe_failure_message do
                specify { expect(subject).to eq "expected TestModel to have validator #{validator_names} on :#{attr_name}" }
              end
            end

            context "with a matching validation" do
              before do
                model.send(validation_method, attr_name, validation_base_options)
              end

              specify { expect(subject).to match(model_or_instance) }

              describe_failure_message_when_negated do
                specify { expect(subject).to eq "expected TestModel to not have validator #{validator_names} on :#{attr_name}" }
              end
            end
          end

          context "when matching with options" do
            subject { matcher_with_options.tap {|m| m.matches?(model_or_instance) } }

            context "with no matching validation" do
              specify { expect(subject).to_not match(model_or_instance) }

              describe_failure_message do
                specify { expect(subject).to eq "expected TestModel to have validator #{validator_names} on :#{attr_name} with options #{matcher_options.inspect}" }
              end
            end

            context "with a matching validation" do
              context "with incorrect options" do
                before do
                  model.send(validation_method, attr_name, validation_base_options)
                end

                specify { expect(subject).to_not match(model_or_instance) }

                describe_failure_message do
                  specify { expect(subject).to eq "expected TestModel to have validator #{validator_names} on :#{attr_name} with options #{matcher_options.inspect}" }
                end
              end

              context "with correct options" do
                before do
                  model.send(validation_method, attr_name, matcher_options)
                end

                specify { expect(subject).to match(model_or_instance) }

                describe_failure_message_when_negated do
                  specify { expect(subject).to eq "expected TestModel to not have validator #{validator_names} on :#{attr_name} with options #{matcher_options.inspect}" }
                end
              end
            end
          end
        end
      end
    end
  end
end