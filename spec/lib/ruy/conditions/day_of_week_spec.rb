require 'spec_helper'

describe Ruy::Conditions::DayOfWeek do
  let(:tz_identifier) { 'America/Argentina/Buenos_Aires' }

  describe '#call' do
    shared_examples_for 'day of week matcher call' do
      let(:vctx) { Ruy::VariableContext.new({time: time}, {}) }


      context 'time zone identifier is passed' do
        subject { described_class.new(:time, value, tz_identifier) }

        context 'value is a symbol' do
          context 'value is the day in the specified time zone' do
            let(:value) { :wednesday }

            it 'returns a truthy value' do
              expect(subject.call(vctx)).to be_truthy
            end
          end

          context 'value is the UTC day' do
            let(:value) { :thursday }

            it 'returns a truthy value' do
              expect(subject.call(vctx)).to be_falsey
            end
          end
        end

        context 'value is a fixnum' do
          context 'value is the the day in the specified time zone' do
            let(:value) { 3 }

            it 'returns a truthy value' do
              expect(subject.call(vctx)).to be_truthy
            end
          end

          context 'value is the UTC day' do
            let(:value) { 4 }

            it 'returns a truthy value' do
              expect(subject.call(vctx)).to be_falsey
            end
          end
        end

        context 'value is invalid' do
          let(:value) { :whatever }

          it 'returns a falsey value' do
            expect(subject.call(vctx)).to be_falsey
          end
        end
      end

      context 'time zone identifier is not passed' do
        subject { described_class.new(:time, value) }

        context 'value is a symbol' do
          context 'value is the UTC day' do
            let(:value) { :thursday }

            it 'returns a truthy value' do
              expect(subject.call(vctx)).to be_truthy
            end
          end
        end

        context 'value is a fixnum' do
          context 'value is the UTC day' do
            let(:value) { 4 }

            it 'returns a truthy value' do
              expect(subject.call(vctx)).to be_truthy
            end
          end
        end

        context 'value is invalid' do
          let(:value) { :whatever }

          it 'returns a falsey value' do
            expect(subject.call(vctx)).to be_falsey
          end
        end
      end
    end

    context 'time is a time object' do
      let(:time) { Time.new(2015, 01, 01, 0, 0, 0, '+00:00') }

      it_behaves_like 'day of week matcher call'
    end
  end

  describe '#==' do
    subject { described_class.new(:timestamp, :dow, tz_identifier) }

    context 'comparing against itself' do
      let(:other) { subject }

      it { is_expected.to eq(other) }
    end

    context 'against the same class with equal attributes' do
      let(:other) { described_class.new(:timestamp, :dow, tz_identifier) }

      it { is_expected.to eq(other) }
    end

    context 'against different class' do
      let(:other) { Ruy::Conditions::All.new }

      it { is_expected.to_not eq(other) }
    end

    context 'against same class with different attribute' do
      let(:other) { described_class.new(:other_timestamp, :dow, tz_identifier) }

      it { is_expected.to_not eq(other) }
    end

    context 'against same class with different value' do
      let(:other) { described_class.new(:timestamp, :other_dow, tz_identifier) }

      it { is_expected.to_not eq(other) }
    end

    context 'against same class with different time zone identifier' do
      let(:other) { described_class.new(:timestamp, :dow, 'UTC') }

      it { is_expected.to_not eq(other) }
    end
  end

  describe '#to_hash' do
    subject { described_class.new(:timestamp, :dow, tz_identifier) }

    it 'returns a hash containing the build parameters' do
      expect(subject.to_hash).to match({node: subject.class.name, params: [:timestamp, :dow, tz_identifier]})
    end

  end
end
