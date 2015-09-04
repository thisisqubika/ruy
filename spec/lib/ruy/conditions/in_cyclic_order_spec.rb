require 'spec_helper'

describe Ruy::Conditions::InCyclicOrder do
  describe '#call' do
    subject(:condition) { Ruy::Conditions::InCyclicOrder.new(left_limit,
      right_limit, :age) }

    context 'when cycle is defined in order' do
      let(:left_limit) { 0 }
      let(:right_limit) { 17 }
      let(:value_in_cycle) { 10 }

      it 'is true when in cycle' do
        context = Ruy::Context.new({:age => value_in_cycle})

        expect(condition.call(context)).to be
      end

      it 'is false when on left side of cycle' do
        context = Ruy::Context.new({:age => left_limit - 1})

        expect(condition.call(context)).to_not be
      end

      it 'is false when on right side of cycle' do
        context = Ruy::Context.new({:age => right_limit + 1})

        expect(condition.call(context)).to_not be
      end
    end

    context 'when cycle is defined in inverse order' do
      let(:left_limit) { 22 }
      let(:right_limit) { 5 }
      let(:value_in_cycle) { 1 }

      it 'is true when in cycle' do
        context = Ruy::Context.new({:age => value_in_cycle})

        expect(condition.call(context)).to be
      end

      it 'is false when on left side of cycle' do
        context = Ruy::Context.new({:age => left_limit - 1})

        expect(condition.call(context)).to_not be
      end

      it 'is false when on right side of cycle' do
        context = Ruy::Context.new({:age => right_limit + 1})

        expect(condition.call(context)).to_not be
      end

      it 'is true when on right side of left limit' do
        context = Ruy::Context.new({:age => left_limit + 1})

        expect(condition.call(context)).to be
      end

      it 'is true when on left side of right limit' do
        context = Ruy::Context.new({:age => right_limit - 1})

        expect(condition.call(context)).to be
      end
    end

  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::InCyclicOrder.new(0, 17, :age) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::InCyclicOrder.new(0, 17, :age) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::InCyclicOrder.new(-1_000, 0, :salary) }

      it { should_not eq(other) }
    end

  end

end
