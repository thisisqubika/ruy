require 'spec_helper'

describe Ruy::Conditions::Assert do

  describe '#call' do
    it 'is true when truth value' do
      context = Ruy::VariableContext.new({:success => true}, {})

      condition = Ruy::Conditions::Assert.new(:success)

      result = condition.call(context)

      expect(result).to be
    end

    it 'is false when false' do
      context = Ruy::VariableContext.new({:success => false}, {})

      condition = Ruy::Conditions::Assert.new(:success)

      result = condition.call(context)

      expect(result).to_not be
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Assert.new(:success) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::Assert.new(:success) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Assert.new(:error) }

      it { should_not eq(other) }
    end
  end
end
