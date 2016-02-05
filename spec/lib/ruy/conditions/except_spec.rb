require 'spec_helper'

describe Ruy::Conditions::Except do

  describe '#call' do

    subject(:condition) do
      Ruy::Conditions::Except.new { assert :sunday }
    end

    it 'is true when inner condition is not satisfied' do
      context = Ruy::Context.new({:sunday => false})

      expect(condition.call(context)).to be
    end

    it 'is false when inner condition is satisfied' do
      context = Ruy::Context.new({:sunday => true})

      expect(condition.call(context)).to_not be
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Except.new { assert :sunday } }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when condition has the same nested condition' do
      let(:other) { Ruy::Conditions::Except.new { assert :sunday } }

      it { should eq(other) }
    end

    context 'when condition has a different nested condition' do
      let(:other) { Ruy::Conditions::Except.new { assert :monday } }

      it { should_not eq(other) }
    end

    context 'when condition is different' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end
  end
end
