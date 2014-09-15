require 'spec_helper'

describe Ruy::TimePattern do
  let(:time_zone_identifier) { 'America/Argentina/Buenos_Aires' }
  let(:timestamp) { "2014-12-31T23:59:59z#{time_zone_identifier}" }
  let(:local_time) { Time.new(2014, 12, 31, 23, 59, 59, '+00:00') }
  let(:utc_time) { TZInfo::Timezone.get(time_zone_identifier).local_to_utc local_time }

  subject { described_class.new(timestamp) }

  describe 'parser' do
    context 'pattern is a timestamp' do
      context 'timestamp specifies a time zone' do
        context 'default time zone argument is not passed' do
          it 'parses a time zoned timestamp' do
            expect(subject).to be_kind_of described_class
          end

          it 'has the correct time zone identifier' do
            expect(subject.tz.identifier).to eq time_zone_identifier
          end
        end

        context 'default time zone argument is passed' do
          let(:default_time_zone_identifier) { 'UTC' }

          subject { described_class.new(timestamp, default_time_zone_identifier) }

          it 'parses a time zoned timestamp' do
            expect(subject).to be_kind_of described_class
          end

          it 'ignores the default time zone argument' do
            expect(subject.tz.identifier).to eq time_zone_identifier
          end
        end
      end

      context 'timestamp does not specify a time zone' do
        let(:timestamp) { '2014-12-31T23:59:59'  }

        context 'default time zone argument is not passed' do
          it 'parses a timestamp without time zone' do
            expect(subject).to be_kind_of described_class
          end

          it 'has UTC as time zone identifier' do
            expect(subject.tz.identifier).to eq 'UTC'
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

      it 'has the correct year in utc' do
        expect(subject.year).to eq utc_time.year
      end

      it 'has the correct month in utc' do
        expect(subject.month).to eq utc_time.month
      end

      it 'has the correct day in utc' do
        expect(subject.day).to eq utc_time.day
      end

      it 'has the correct hours in utc' do
        expect(subject.hour).to eq utc_time.hour
      end

      it 'has the correct minutes in utc' do
        expect(subject.min).to eq utc_time.min
      end

      it 'has the correct seconds in utc' do
        expect(subject.sec).to eq utc_time.sec
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
    it 'returns the corresponding ruy well-formed timestamp' do
      expect(subject.to_s).to eq timestamp
    end
  end

  describe 'comparison operators' do
    let(:equal_time) { utc_time }
    let(:future_time) { equal_time + 1 }
    let(:past_time) { equal_time - 1 }

    let(:equal_time_pattern) { described_class.new(timestamp) }
    let(:newer_time_pattern) { described_class.new("2015-01-01T00:00:00zAmerica/Argentina/Buenos_Aires") }
    let(:older_time_pattern) { described_class.new("2014-12-31T23:59:58zAmerica/Argentina/Buenos_Aires") }

    describe '#<=>' do
      context 'passing a time object' do
        context 'with an equal time' do
          it 'returns 0' do
            expect(subject <=> equal_time).to eq 0
          end
        end

        context 'with a future time' do
          it 'returns -1' do
            expect(subject <=> future_time).to eq -1
          end
        end

        context 'with a past time' do
          it 'returns 1' do
            expect(subject <=> past_time).to eq 1
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns 0' do
            expect(subject <=> equal_time_pattern).to eq 0
          end
        end

        context 'with a newer time pattern' do
          it 'returns -1' do
            expect(subject <=> newer_time_pattern).to eq -1
          end
        end

        context 'with an older time pattern' do
          it 'returns 1' do
            expect(subject <=> older_time_pattern).to eq 1
          end
        end
      end
    end

    describe '#>' do
      context 'passing a time object' do
        context 'with an equal time' do
          it 'returns a falsey value' do
            expect(subject > equal_time).to be_falsey
          end
        end

        context 'with a past time' do
          it 'returns a truthy value' do
            expect(subject > past_time).to be_truthy
          end
        end

        context 'with a future time' do
          it 'returns a falsey value' do
            expect(subject > future_time).to be_falsey
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns a falsey value' do
            expect(subject > equal_time_pattern).to be_falsey
          end
        end

        context 'with a newer time pattern' do
          it 'returns a falsey value' do
            expect(subject > newer_time_pattern).to be_falsey
          end
        end

        context 'with an older time pattern' do
          it 'returns a truthy value' do
            expect(subject > older_time_pattern).to be_truthy
          end
        end
      end
    end

    describe '#>=' do
      context 'passing a time object' do
        context 'with an equal time' do
          it 'returns a truthy value' do
            expect(subject >= equal_time).to be_truthy
          end
        end

        context 'with a future time' do
          it 'returns a falsey value' do
            expect(subject >= future_time).to be_falsey
          end
        end

        context 'with a past time' do
          it 'returns a truthy value' do
            expect(subject >= past_time).to be_truthy
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns a truthy value' do
            expect(subject >= equal_time_pattern).to be_truthy
          end
        end

        context 'with a newer time pattern' do
          it 'returns a falsey value' do
            expect(subject >= newer_time_pattern).to be_falsey
          end
        end

        context 'with an older time pattern' do
          it 'returns a truthy value' do
            expect(subject >= older_time_pattern).to be_truthy
          end
        end
      end
    end

    describe '#<' do
      context 'passing a time object' do
        context 'with an equal time' do
          it 'returns a falsey value' do
            expect(subject < equal_time).to be_falsey
          end
        end

        context 'with a future time' do
          it 'returns truthy value' do
            expect(subject < future_time).to be_truthy
          end
        end

        context 'with a past time' do
          it 'returns a falsey value' do
            expect(subject < past_time).to be_falsey
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns a falsey value' do
            expect(subject < equal_time_pattern).to be_falsey
          end
        end

        context 'with a newer time pattern' do
          it 'returns a truthy value' do
            expect(subject < newer_time_pattern).to be_truthy
          end
        end

        context 'with an older time pattern' do
          it 'returns a falsey value' do
            expect(subject < older_time_pattern).to be_falsey
          end
        end
      end

    end

    describe '#<=' do
      context 'passing a time object' do
        context 'with an equal time' do
          it 'returns a truthy value' do
            expect(subject <= equal_time).to be_truthy
          end
        end

        context 'with a future time' do
          it 'returns truthy value' do
            expect(subject <= future_time).to be_truthy
          end
        end

        context 'with a past time' do
          it 'returns a falsey value' do
            expect(subject <= past_time).to be_falsey
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns a truthy value' do
            expect(subject <= equal_time_pattern).to be_truthy
          end
        end

        context 'with a newer time pattern' do
          it 'returns a truthy value' do
            expect(subject <= newer_time_pattern).to be_truthy
          end
        end

        context 'with an older time pattern' do
          it 'returns a falsey value' do
            expect(subject <= older_time_pattern).to be_falsey
          end
        end
      end
    end

    describe '#==' do
      context 'passing a time object' do
        context 'passing an equal time' do
          it 'returns a truthy value' do
            expect(subject == equal_time).to be_truthy
          end
        end

        context 'passing a future time' do
          it 'returns a falsey value' do
            expect(subject == future_time).to be_falsey
          end
        end

        context 'passing a past time' do
          it 'returns a falsey value' do
            expect(subject == past_time).to be_falsey
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns a truthy value' do
            expect(subject == equal_time_pattern).to be_truthy
          end
        end

        context 'with a newer time pattern' do
          it 'returns a falsey value' do
            expect(subject == newer_time_pattern).to be_falsey
          end
        end

        context 'with an older time pattern' do
          it 'returns a falsey value' do
            expect(subject == older_time_pattern).to be_falsey
          end
        end
      end
    end

    describe '#!=' do
      context 'passing a time object' do
        context 'passing an equal time' do
          it 'returns a falsey value' do
            expect(subject != equal_time).to be_falsey
          end
        end

        context 'passing a future time' do
          it 'returns a truthy value' do
            expect(subject != future_time).to be_truthy
          end
        end

        context 'passing a past time' do
          it 'returns a truthy value' do
            expect(subject != past_time).to be_truthy
          end
        end
      end

      context 'passing a time pattern object' do
        context 'with an equal time pattern' do
          it 'returns a falsey value' do
            expect(subject != equal_time_pattern).to be_falsey
          end
        end

        context 'with a newer time pattern' do
          it 'returns a truthy value' do
            expect(subject != newer_time_pattern).to be_truthy
          end
        end

        context 'with an older time pattern' do
          it 'returns a truthy value' do
            expect(subject != older_time_pattern).to be_truthy
          end
        end
      end
    end

  end

end
