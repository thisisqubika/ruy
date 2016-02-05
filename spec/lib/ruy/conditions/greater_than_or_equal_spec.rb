require 'spec_helper'

describe Ruy::Conditions::GreaterThanOrEqual do

  describe '#call' do
    context 'when instance receives no attribute' do
      subject(:condition) { Ruy::Conditions::GreaterThanOrEqual.new(18) }

      it 'is true when value is equal' do
        context = Ruy::Context.new(18)

        expect(condition.call(context)).to be
      end

      it 'is true when value is bigger' do
        context = Ruy::Context.new(19)

        expect(condition.call(context)).to be
      end

      it 'is false when value is smaller' do
        context = Ruy::Context.new(17)

        expect(condition.call(context)).to_not be
      end
    end

    context 'when instance receives an attribute' do
      subject(:condition) { Ruy::Conditions::GreaterThanOrEqual.new(18, :age) }

      it 'is true when value is equal' do
        context = Ruy::Context.new({ :age => 18 })

        expect(condition.call(context)).to be
      end

      it 'is true when value is bigger' do
        context = Ruy::Context.new({ :age => 19 })

        expect(condition.call(context)).to be
      end

      it 'is false when value is smaller' do
        context = Ruy::Context.new({ :age => 17 })

        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::GreaterThanOrEqual.new(1_000, :salary) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when condition has the same attributes' do
      let(:other) { Ruy::Conditions::GreaterThanOrEqual.new(1_000, :salary) }

      it { should eq(other) }
    end

    context 'when condition is different' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when condition has different values' do
      let(:other) { Ruy::Conditions::GreaterThanOrEqual.new(5, :salary) }

      it { should_not eq(other) }
    end

    context 'when condition has different attributes' do
      let(:other) { Ruy::Conditions::GreaterThanOrEqual.new(5, :age) }

      it { should_not eq(other) }
    end

    context 'when condition has no attributes' do
      let(:other) { Ruy::Conditions::GreaterThanOrEqual.new(5) }

      it { should_not eq(other) }
    end
  end
end
