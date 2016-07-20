require 'spec_helper'

describe Ruy::Conditions::Belong do

  describe '#call' do
    context 'when instance receives no attribute' do
      subject(:condition) { Ruy::Conditions::Belong.new([:sunday, :monday]) }

      it 'is true when included' do
        context = Ruy::Context.new(:sunday)

        expect(condition.call(context)).to be
      end

      it 'is false when not included' do
        context = Ruy::Context.new(:wednesday)

        expect(condition.call(context)).to_not be
      end
    end

    context 'when instance receives an attribute' do
      subject(:condition) { Ruy::Conditions::Belong.new([:sunday, :monday], :day_of_week) }

      it 'is true when in' do
        context = Ruy::Context.new({:day_of_week => :sunday})

        expect(condition.call(context)).to be
      end

      it 'is false when not in' do
        context = Ruy::Context.new({:day_of_week => :tuesday})

        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Belong.new([:sunday, :monday], :day_of_week) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when condition has the same attributes' do
      let(:other) { Ruy::Conditions::Belong.new([:sunday, :monday], :day_of_week) }

      it { should eq(other) }
    end

    context 'when condition is different' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when condition has a different attribute' do
      let(:other) { Ruy::Conditions::Belong.new([:sunday, :monday], :dow) }

      it { should_not eq(other) }
    end

    context 'when condition has different values' do
      let(:other) { Ruy::Conditions::Belong.new([:saturday], :day_of_week) }

      it { should_not eq(other) }
    end

    context 'when condition has no attributes' do
      let(:other) { Ruy::Conditions::Belong.new([:saturday]) }

      it { should_not eq(other) }
    end

  end
end
