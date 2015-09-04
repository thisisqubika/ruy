require 'spec_helper'

describe Ruy::Conditions::Between do

  describe '#call' do
    subject(:condition) { Ruy::Conditions::Between.new(0, 17, :age) }

    it 'is true when in range' do
      context = Ruy::Context.new({:age => 10})

      expect(condition.call(context)).to be
    end

    it 'is false when out of range' do
      context = Ruy::Context.new({:age => 18})

      expect(condition.call(context)).to_not be
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Between.new(0, 17, :age) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::Between.new(0, 17, :age) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Between.new(-1_000, 0, :salary) }

      it { should_not eq(other) }
    end
  end
end
