require 'pp'
require 'spec_helper'

describe Ruy::RuleSet do

  describe '#to_s' do
    context 'with a full defined rule set' do
      let(:rule_set) do
        set = Ruy::RuleSet.new

        set.any do
          between :age, 18, 22
          eq :enabled, true
        end

        set.any do
          between :age, 0, 17
          eq :enabled, false
        end

        set.tz('America/New_York') do
          eq :timestamp, '2015-01-01T00:00:00'
        end

        set.outcome 'I matched'

        set.fallback 'Nothing matched'
        set
      end

      let(:representation) do
        <<EOS
any do
  between :age, 18, 22
  eq :enabled, true
end

any do
  between :age, 0, 17
  eq :enabled, false
end

tz "America/New_York" do
  eq :timestamp, "2015-01-01T00:00:00"
end

outcome "I matched"

fallback "Nothing matched"
EOS
      end

      it 'matches the expected representation' do
        expect(rule_set.to_s).to eq(representation)
      end
    end

    context 'with a rule set that only has a fallback' do
      let(:rule_set) do
        set = Ruy::RuleSet.new

        set.fallback 'Nothing matched'
        set
      end

      let(:representation) do
        <<EOS
fallback "Nothing matched"
EOS
      end

      it 'matches the expected representation' do
        expect(rule_set.to_s).to eq(representation)
      end
    end

    context 'with a rule set that only has an outcome' do
      let(:rule_set) do
        set = Ruy::RuleSet.new

        set.outcome 'It matched' do
          eq :enabled, true
        end

        set
      end

      let(:representation) do
        <<EOS
outcome "It matched" do
  eq :enabled, true
end
EOS
      end

      it 'matches the expected representation' do
        expect(rule_set.to_s).to eq(representation)
      end
    end
  end

end
