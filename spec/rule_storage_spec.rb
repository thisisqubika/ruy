require 'spec_helper'

describe Ruy::RuleStorage do
  let(:ctx) { {:test => true} }
  let(:container_with_rules) do
    rule_1 = Ruy::RuleSet.new
    rule_1.instance_eval do
      eq :test, true
      outcome 1
    end

    rule_2 = Ruy::RuleSet.new
    rule_2.instance_eval do
      eq :test, true
      outcome 2
    end

    described_class.new(nil, [rule_1, rule_2])
  end

  describe '#evaluate_all' do
    it 'should return the outcomes for all the rule sets' do
      expect(container_with_rules.evaluate_all(ctx)).to eq([1, 2])
    end

    it 'should not return nil values' do
      not_applicable_rule = Ruy::RuleSet.new
      not_applicable_rule.instance_eval do
        eq :test, false
        outcome 1
      end

      rule_set = described_class.new(nil, [not_applicable_rule])
      expect(rule_set.evaluate_all(ctx)).to be_empty
    end

  end

  describe '#load_rules' do
    let(:adapter) { double(:adapter).as_null_object }
    let(:params) { double(:params) }

    it 'should delegate the method call to the adapter' do
      expect(adapter).to receive(:load_rules)

      described_class.new(adapter).load_rules
    end

    it 'should pass the given params to the adapter' do
      expect(adapter).to receive(:load_rules).with(params)

      described_class.new(adapter).load_rules(params)
    end
  end

  describe '#evaluate_first' do
    it 'should return only the outcome of the first rule that apply' do
      expect(container_with_rules.evaluate_first(ctx)).to be(1)
    end
  end
end
