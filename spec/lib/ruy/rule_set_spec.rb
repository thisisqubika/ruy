require 'pp'
require 'spec_helper'

describe Ruy::RuleSet do

  describe '#call' do
    let(:rule_set) do
      set = Ruy::RuleSet.new

      set.assert :flag

      set.outcome :success
      set.fallback :failure

      set
    end

    it 'resolves to outcome when conditions met' do
      result = rule_set.call(:flag => true)

      expect(result).to eq(:success)
    end

    it 'resolves to fallback when conditions do not met' do
      result = rule_set.call(:flag => false)

      expect(result).to eq(:failure)
    end
  end

  describe 'let' do
    let(:rule_set) do
      set = Ruy::RuleSet.new

      set.let :expensive
      set.let :max

      set.greater_than_or_equal :expensive, 10
      set.less_than :expensive, 100

      set
    end

    it 'resolves only once' do
      resolved = 0
      ctx = {
        :expensive => -> { resolved += 1 }
      }

      rule_set.call(ctx)

      expect(resolved).to eq(1)
    end

    it 'does not resolve unused lets' do
      resolved = false
      ctx = {
        :expensive => -> { 0 },
        :max => -> { resolved = true }
      }

      rule_set.call(ctx)

      expect(resolved).to_not be
    end
  end

  describe '#to_s' do
    context 'with a full defined rule set' do
      let(:rule_set) do
        set = Ruy::RuleSet.new

        set.let :expensive_count
        set.let :randomness

        set.eq :city, 'New York'

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
let :expensive_count
let :randomness

eq :city, "New York"

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
