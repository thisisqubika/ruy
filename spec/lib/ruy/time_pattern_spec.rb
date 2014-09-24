require 'spec_helper'

describe Ruy::TimePattern do
  let(:time_zone_identifier) { 'America/Argentina/Buenos_Aires' }
  let(:timestamp) { "2014-12-31T23:59:59z#{time_zone_identifier}" }
  let(:tz) { TZInfo::Timezone.get(time_zone_identifier) }
  let(:local_time) { Time.new(2014, 12, 31, 23, 59, 59, 0) }
  let(:utc_time) { tz.local_to_utc local_time }

  subject { described_class.new(timestamp) }

  describe 'parser' do
    context 'pattern is a full timestamp' do
      context 'timestamp specifies a time zone' do
        context 'default time zone argument is not passed' do
          it 'parses a time zoned timestamp' do
            expect(subject).to be_kind_of described_class
          end

          it 'has the correct time zone identifier' do
            expect(subject.time_zone).to eq time_zone_identifier
          end
        end

        context 'default time zone argument is passed' do
          let(:default_time_zone_identifier) { 'UTC' }

          subject { described_class.new(timestamp, default_time_zone_identifier) }

          it 'parses a time zoned timestamp' do
            expect(subject).to be_kind_of described_class
          end

          it 'ignores the default time zone argument' do
            expect(subject.time_zone).to eq time_zone_identifier
          end
        end
      end

      context 'timestamp does not specify a time zone' do
        let(:timestamp) { '2014-12-31T23:59:59' }

        context 'default time zone argument is not passed' do
          it 'parses a timestamp without time zone' do
            expect(subject).to be_kind_of described_class
          end

          it 'does not have a time zone' do
            expect(subject.time_zone).to be_nil
          end
        end

        context 'default time zone argument is passed' do
          let(:default_time_zone_identifier) { time_zone_identifier }

          subject { described_class.new(timestamp, default_time_zone_identifier) }

          it 'parses a timestamp without time zone' do
            expect(subject).to be_kind_of described_class
          end

          it 'has the default time zone as time zone identifier' do
            expect(subject.tz.identifier).to eq time_zone_identifier
          end
        end
      end

      it 'has the correct year' do
        expect(subject.year).to eq 2014
      end

      it 'has the correct month' do
        expect(subject.month).to eq 12
      end

      it 'has the correct day' do
        expect(subject.day).to eq 31
      end

      it 'has the correct hours' do
        expect(subject.hour).to eq 23
      end

      it 'has the correct minutes' do
        expect(subject.min).to eq 59
      end

      it 'has the correct seconds' do
        expect(subject.sec).to eq 59
      end

      it 'has the correct utc offset' do
        expect(subject.utc_offset).to eq tz.current_period.utc_total_offset
      end

      it 'has the correct local time' do
        expect(subject.local).to eq local_time
      end

      it 'has the correct utc time' do
        expect(subject.utc).to eq utc_time
      end

    end

    context 'pattern contains wildcards' do
      context 'with undefined year' do
        let(:timestamp) { '*-12-31T23:59:59' }

        it 'parses a time zoned timestamp' do
          expect(subject).to be_kind_of described_class
        end

        it 'does not define a year' do
          expect(subject.year).to be_nil
        end
      end

      context 'with undefined month' do
        let(:timestamp) { '2014-*-31T23:59:59' }

        it 'parses a time zoned timestamp' do
          expect(subject).to be_kind_of described_class
        end

        it 'does not define a month' do
          expect(subject.month).to be_nil
        end
      end

      context 'with undefined day' do
        let(:timestamp) { '2014-12-*T23:59:59' }

        it 'parses a time zoned timestamp' do
          expect(subject).to be_kind_of described_class
        end

        it 'does not define a day' do
          expect(subject.day).to be_nil
        end
      end

      context 'with undefined hour' do
        let(:timestamp) { '2014-12-31T*:59:59' }

        it 'parses a time zoned timestamp' do
          expect(subject).to be_kind_of described_class
        end

        it 'does not define an hour' do
          expect(subject.hour).to be_nil
        end
      end

      context 'with undefined minute' do
        let(:timestamp) { '2014-12-31T23:*:59' }

        it 'parses a time zoned timestamp' do
          expect(subject).to be_kind_of described_class
        end

        it 'does not define a minute' do
          expect(subject.min).to be_nil
        end
      end

      context 'with undefined second' do
        let(:timestamp) { '2014-12-31T23:59:*' }

        it 'parses a time zoned timestamp' do
          expect(subject).to be_kind_of described_class
        end

        it 'does not define a second' do
          expect(subject.sec).to be_nil
        end
      end

    end

    context 'pattern is malformed' do
      let(:malformed_timestamp) { '2014-12-31T23:59:59z' }

      it 'raises an argument error' do
        expect { described_class.new(malformed_timestamp) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#to_s' do
    context 'pattern is a full timestamp' do
      it 'returns the corresponding well-formed timestamp' do
        expect(subject.to_s).to eq timestamp
      end
    end

    context 'pattern contains wildcards' do
      context 'with undefined year' do
        let(:timestamp) { '*-12-31T23:59:59zAmerica/Argentina/Buenos_Aires' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq timestamp
        end
      end

      context 'with undefined month' do
        let(:timestamp) { '2014-*-31T23:59:59zAmerica/Argentina/Buenos_Aires' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq timestamp
        end
      end

      context 'with undefined day' do
        let(:timestamp) { '2014-12-*T23:59:59zAmerica/Argentina/Buenos_Aires' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq timestamp
        end
      end

      context 'with undefined hour' do
        let(:timestamp) { '2014-12-31T*:59:59zAmerica/Argentina/Buenos_Aires' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq timestamp
        end
      end

      context 'with undefined minute' do
        let(:timestamp) { '2014-12-31T23:*:59zAmerica/Argentina/Buenos_Aires' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq timestamp
        end
      end

      context 'with undefined second' do
        let(:timestamp) { '2014-12-31T23:59:*zAmerica/Argentina/Buenos_Aires' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq timestamp
        end
      end

      context 'with undefined time zone' do
        let(:timestamp) { '2014-12-31T23:59:59' }

        it 'returns the corresponding well-formed timestamp' do
          expect(subject.to_s).to eq "#{timestamp}"
        end
      end
    end

    context 'pattern does not have a time zone' do
      let(:timestamp) { '2014-12-31T23:59:59' }

      it 'returns the corresponding well-formed timestamp' do
        expect(subject.to_s).to eq timestamp
      end
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the pattern' do
      expect(subject.inspect).to eq timestamp.inspect
    end
  end

  shared_examples_for 'time pattern comparison' do
    context 'subject is a full timestamp' do
      subject { described_class.new("2014-12-31T23:00:00z#{time_zone_identifier}") }

      context 'object is a time' do
        context 'object is greater than subject' do
          let(:object) { Time.new(2015, 1, 1, 2, 0, 1, 0) }

          it 'evaluates to the expected value' do
            expect(subject.send(method, object)).to eq expected_value_for_greater_than
          end
        end

        context 'object is equal to subject' do
          let(:object) { Time.new(2015, 1, 1, 2, 0, 0, 0) }

          it 'evaluates to the expected value' do
            expect(subject.send(method, object)).to eq expected_value_for_equal_to
          end
        end

        context 'object is less than subject' do
          let(:object) { Time.new(2015, 1, 1, 1, 59, 59, 0) }

          it 'evaluates to the expected value' do
            expect(subject.send(method, object)).to eq expected_value_for_less_than
          end
        end
      end
    end

    context 'subject contains wildcards' do
      subject { described_class.new("*-11-*T23:*:*z#{time_zone_identifier}") }

      context 'object is a time' do
        context 'object is greater than subject' do
          let(:object) { Time.new(2015, 1, 1, 2, 0, 1, 0) }

          it 'evaluates to the expected value' do
            expect(subject.send(method, object)).to eq expected_value_for_greater_than
          end
        end

        context 'object is equal to subject' do
          let(:object) { Time.new(2014, 12, 1, 2, 0, 0, 0) }

          it 'evaluates to the expected value' do
            expect(subject.send(method, object)).to eq expected_value_for_equal_to
          end
        end

        context 'object is less than subject' do
          let(:object) { Time.new(2014, 11, 1, 2, 0, 0, 0) }

          it 'evaluates to the expected value' do
            expect(subject.send(method, object)).to eq expected_value_for_less_than
          end
        end
      end
    end

  end

  describe '#<=>' do
    let(:method) { '<=>' }
    let(:expected_value_for_greater_than) { -1 }
    let(:expected_value_for_equal_to) { 0 }
    let(:expected_value_for_less_than) { 1 }

    it_behaves_like 'time pattern comparison'

    context 'comparing against a non-time object' do
      let(:object) { 1 }

      it 'returns nil' do
        expect(subject <=> object).to be_nil
      end
    end
  end

  describe '#>' do
    let(:method) { '>' }
    let(:expected_value_for_greater_than) { false }
    let(:expected_value_for_equal_to) { false }
    let(:expected_value_for_less_than) { true }

    it_behaves_like 'time pattern comparison'
  end

  describe '#>=' do
    let(:method) { '>=' }
    let(:expected_value_for_greater_than) { false }
    let(:expected_value_for_equal_to) { true }
    let(:expected_value_for_less_than) { true }

    it_behaves_like 'time pattern comparison'
  end

  describe '#<' do
    let(:method) { '<' }
    let(:expected_value_for_greater_than) { true }
    let(:expected_value_for_equal_to) { false }
    let(:expected_value_for_less_than) { false }

    it_behaves_like 'time pattern comparison'
  end

  describe '#<=' do
    let(:method) { '<=' }
    let(:expected_value_for_greater_than) { true }
    let(:expected_value_for_equal_to) { true }
    let(:expected_value_for_less_than) { false }

    it_behaves_like 'time pattern comparison'
  end

  describe '#==' do
    let(:method) { '==' }
    let(:expected_value_for_greater_than) { false }
    let(:expected_value_for_equal_to) { true }
    let(:expected_value_for_less_than) { false }

    it_behaves_like 'time pattern comparison'

    context 'object is a time pattern' do
      context 'object is equal to the time pattern' do
        let(:object) { described_class.new(timestamp) }

        it 'returns a truthy value' do
          expect(subject == object).to be_truthy
        end
      end

      context 'object is not equal to the time pattern' do
        let(:object) { described_class.new('2013-02-02T13:00:00') }

        it 'returns a falsey value' do
          expect(subject == object).to be_falsey
        end
      end
    end

    context 'object is of generic class' do
      let(:object) { Object.new }

      it 'returns a falsey value' do
        expect(subject == object).to be_falsey
      end
    end
  end

  describe '#!=' do
    let(:method) { '!=' }
    let(:expected_value_for_greater_than) { true }
    let(:expected_value_for_equal_to) { false }
    let(:expected_value_for_less_than) { true }

    it_behaves_like 'time pattern comparison'
  end

end
