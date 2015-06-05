require 'spec_helper'

describe Ruy::Conditions::TZ do
  describe '#call' do
    let(:tz_identifier) { 'America/Argentina/Buenos_Aires' }
    let(:time) { Time.new(2015, 1, 1, 0, 0, 0, 0) }
    let(:ctx) { Ruy::Context.new({time: time}) }

    subject { described_class.new(tz_identifier) }

    describe 'day of week' do
      context 'with day name' do
        let(:day_of_week) { :wednesday }

        before do
          subject.day_of_week day_of_week, :time
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      context 'with day number' do
        let(:day_of_week) { 3 }

        before do
          subject.day_of_week day_of_week, :time
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end
    end

    shared_examples_for 'tz wrapped comparators' do
      describe 'equality' do
        before do
          subject.eq value, :time
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'between' do
        before do
          subject.between left_value, right_value, :time
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'greater than or equal' do
        before do
          subject.greater_than_or_equal left_value, :time
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'less than' do
        before do
          subject.less_than right_value, :time
        end

        it 'returns a truthy value' do
          expect(subject.call(ctx)).to be_truthy
        end
      end

      describe 'less than or equal' do
        before do
          subject.less_than_or_equal right_value, :time
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

      it_behaves_like 'tz wrapped comparators'
    end

    context 'values have wildcards' do
      let(:value) { "2014-12-*T*:*:*z#{tz_identifier}" }
      let(:left_value) { "*-11-*T*:*:*z#{tz_identifier}" }
      let(:right_value) { "2014-*-*T22:*:00z#{tz_identifier}" }

      it_behaves_like 'tz wrapped comparators'
    end

    context 'values don\'t have their time zone identifiers' do
      let(:value) { "2014-12-31T21:00:00" }
      let(:left_value) { "2014-12-31T20:00:00" }
      let(:right_value) { "2014-12-31T22:00:00" }

      it_behaves_like 'tz wrapped comparators'
    end

  end

end
