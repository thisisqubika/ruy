require 'spec_helper'

describe Ruy::Conditions::Except do

  describe '#call' do

    subject(:condition) do
      Ruy::Conditions::Except.new { assert :sunday }
    end

    it 'is true when !sunday' do
      context = Ruy::Context.new({:sunday => false})

      expect(condition.call(context)).to be
    end

    it 'is false when sunday' do
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

    context 'when same nested condition' do
      let(:other) { Ruy::Conditions::Except.new { assert :sunday } }

      it { should eq(other) }
    end

    context 'when different nested condition' do
      let(:other) { Ruy::Conditions::Except.new { assert :monday } }

      it { should_not eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end
  end
end
