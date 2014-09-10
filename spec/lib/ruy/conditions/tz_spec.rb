require 'spec_helper'

describe Ruy::Conditions::TZ do
  describe '#call' do
    let(:tz_identifier) { 'America/Argentina/Buenos_Aires' }
    let(:time) { Time.new(2015, 1, 1, 0, 0, 0, '+00:00') }
    let(:ctx) { Ruy::VariableContext.new({time: time}, []) }

    subject { described_class.new(tz_identifier) }

    shared_examples_for 'tz wrapped matchers' do
      describe 'day_of_week' do
        before do
          subject.day_of_week :time, :wednesday
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'equality' do
        before do
          subject.eq :time, value
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'between' do
        before do
          subject.between :time, left_value, right_value
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'greater than or equal' do
        before do
          subject.greater_than_or_equal :time, left_value
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'less than' do
        before do
          subject.less_than :time, right_value
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'less than or equal' do
        before do
          subject.less_than_or_equal :time, right_value
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end
    end

    context 'values have their time zone identifiers' do
      let(:value) { "2014-12-31T21:00:00z#{tz_identifier}" }
      let(:left_value) { "2014-12-31T20:00:00z#{tz_identifier}" }
      let(:right_value) { "2014-12-31T22:00:00z#{tz_identifier}" }

      it_behaves_like 'tz wrapped matchers'
    end

    context 'values don\'t have their time zone identifiers' do
      let(:value) { "2014-12-31T21:00:00" }
      let(:left_value) { "2014-12-31T20:00:00" }
      let(:right_value) { "2014-12-31T22:00:00" }

      it_behaves_like 'tz wrapped matchers'
    end

  end

  describe '#to_hash' do
    let(:value) { "2014-12-31T21:00:00z#{tz_identifier}" }
    let(:tz_identifier) { 'America/Argentina/Buenos_Aires' }

    subject { described_class.new(tz_identifier)}

    before do
      subject.eq :time, value
      subject.day_of_week :time, :sunday
    end

    it 'returns a hash containing the build parameters' do
      expect(subject.to_hash).to match({node: subject.class.name, params: [tz_identifier],
        conditions: [subject.conditions[0].to_hash, subject.conditions[1].to_hash]})
    end
  end

end
