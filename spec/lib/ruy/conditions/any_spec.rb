require 'spec_helper'

describe Ruy::Conditions::Any do

  describe '#call' do
    subject(:condition) do
      Ruy::Conditions::Any.new.tap do |rule|
        rule.assert :active
        rule.assert :enabled
      end
    end

    it 'is true when some condition is met' do
      context = Ruy::Context.new({:active => true})

      expect(condition.call(context)).to be
    end

    it 'is true when some other condition is met' do
      context = Ruy::Context.new({:enabled => true})

      expect(condition.call(context)).to be
    end

    it 'is false when no conditions are met' do
      context = Ruy::Context.new({:active => false, :enabled => false})

      expect(condition.call(context)).to_not be
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Any.new }

    before do
      condition.conditions << Ruy::Conditions::Assert.new(:c1)
    end

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'having same sub-conditions' do
      let(:other) { Ruy::Conditions::Any.new }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should eq(other) }
    end

    context 'having same sub-conditions but different rule' do
      let(:other) { Ruy::Conditions::All.new }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should_not eq(other) }
    end

    context 'when sub-conditions are different' do
      let(:other) { Ruy::Conditions::Any.new }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c99)
      end

      it { should_not eq(other) }
    end
  end
end
