require 'spec_helper'

describe Ruy::Conditions::InCyclicOrder do
  describe '#call' do
    context 'when cycle is defined in order' do
      subject(:condition) { Ruy::Conditions::InCyclicOrder.new(0, 17, :age) }

      it 'is true when in range' do
        context = Ruy::VariableContext.new({:age => 10}, {})

        expect(condition.call(context)).to be
      end

      it 'is false when out of range' do
        context = Ruy::VariableContext.new({:age => 18}, {})

        expect(condition.call(context)).to_not be
      end

      context 'when nested conditions' do
        subject(:condition) do
          Ruy::Conditions::InCyclicOrder.new(0, 17, :age) do
            assert :success
          end
        end

        it 'is true when nested succeeds' do
          context = Ruy::VariableContext.new({:age => 10, :success => true}, {})

          expect(condition.call(context)).to be
        end

        it 'is false when nested fails' do
          context = Ruy::VariableContext.new({:age => 10, :success => false}, {})

          expect(condition.call(context)).to_not be
        end
      end
    end

    context 'when cycle is defined in inverse order' do
      subject(:condition) { Ruy::Conditions::InCyclicOrder.new(23, 5, :time) }

      it 'is true when in cycle' do
        context = Ruy::VariableContext.new({:time => 1}, {})

        expect(condition.call(context)).to be
      end

      it 'is false when out of cycle' do
        context = Ruy::VariableContext.new({:time => 22}, {})

        expect(condition.call(context)).to_not be
      end

      context 'when nested conditions' do
        subject(:condition) do
          Ruy::Conditions::InCyclicOrder.new(23, 5, :time) do
            assert :success
          end
        end

        it 'is true when nested succeeds' do
          context = Ruy::VariableContext.new({:time => 1, :success => true}, {})

          expect(condition.call(context)).to be
        end

        it 'is false when nested fails' do
          context = Ruy::VariableContext.new({:time => 1, :success => false}, {})

          expect(condition.call(context)).to_not be
        end
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
