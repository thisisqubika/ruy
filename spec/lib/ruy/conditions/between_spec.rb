require 'spec_helper'

describe Ruy::Conditions::Between do

  describe '#call' do
    context 'instance receives no attribute' do
      subject(:condition) { described_class.new(0, 17) }

      it 'is true when context is in range' do
        context = Ruy::Context.new(10)
        expect(condition.call(context)).to be
      end

      it 'is false when context is out of range' do
        context = Ruy::Context.new(18)
        expect(condition.call(context)).to_not be
      end
    end

    context 'instance receives an attribute' do
      subject(:condition) { described_class.new(0, 17, :age) }

      it 'is true when attribute resolves to value in range' do
        context = Ruy::Context.new({:age => 10})
        expect(condition.call(context)).to be
      end

      it 'is false when attribute resolves to value out of range' do
        context = Ruy::Context.new({:age => 18})

        expect(condition.call(context)).to_not be
      end
    end

    context 'when range' do
      subject(:condition) { described_class.new(0..17, :age) }

      it 'is true when attribute resolves to a value range' do
        context = Ruy::Context.new({:age => 10})
        expect(condition.call(context)).to be
      end

      it 'is false when attribute resolves to value out of range' do
        context = Ruy::Context.new({:age => 18})

        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    shared_examples_for 'condition equality' do |*attrs|
      subject(:condition) { Ruy::Conditions::Between.new(0, 17, *attrs) }

      context 'when comparing against self' do
        let(:other) { condition }

        it { should eq(other) }
      end

      context 'when condition has the same attributes' do
        let(:other) { Ruy::Conditions::Between.new(0, 17, *attrs) }

        it { should eq(other) }
      end

      context 'when condition is different' do
        let(:other) { Ruy::Conditions::All.new }

        it { should_not eq(other) }
      end

      context 'when condition has different values' do
        let(:other) { Ruy::Conditions::Between.new(-1_000, 0, *attrs) }
      end

      context 'when condition has different attributes' do
        let(:other) { Ruy::Conditions::Between.new(0, 17, :salary) }

        it { should_not eq(other) }
      end
    end

    context 'instance receives no attribute' do
      it_behaves_like 'condition equality'
    end

    context 'instance receives an attribute' do
      it_behaves_like 'condition equality', :age
    end

  end
end
