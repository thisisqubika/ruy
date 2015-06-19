require 'spec_helper'

describe Ruy::Conditions::In do

  describe '#call' do
    subject(:condition) { Ruy::Conditions::In.new([:sunday, :monday], :day_of_week) }

    it 'is true when in' do
      context = Ruy::Context.new({:day_of_week => :sunday})

      expect(condition.call(context)).to be
    end

    it 'is false when not in' do
      context = Ruy::Context.new({:day_of_week => :tuesday})

      expect(condition.call(context)).to_not be
    end

    context 'when nested conditions' do
      subject(:condition) do
        Ruy::Conditions::In.new([:sunday, :monday], :day_of_week) do
          assert :success
        end
      end

      it 'is true when nested succeeds' do
        context = Ruy::Context.new({:day_of_week => :sunday, :success => true})

        expect(condition.call(context)).to be
      end

      it 'is false when nested fails' do
        context = Ruy::Context.new({:day_of_week => :sunday, :success => false})

        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::In.new([:sunday, :monday], :day_of_week) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition' do
      let(:other) { Ruy::Conditions::In.new([:sunday, :monday], :day_of_week) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different attribute' do
      let(:other) { Ruy::Conditions::In.new([:sunday, :monday], :dow) }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::In.new([:saturday], :day_of_week) }

      it { should_not eq(other) }
    end

  end
end
