require 'spec_helper'

describe Ruy::Conditions::Include do

  describe '#call' do
    context 'when instance receives no attribute' do
     subject(:condition) { Ruy::Conditions::Include.new(:sunday) }

      it 'is true when value is included' do
        context = Ruy::Context.new([:sunday, :monday])

        expect(condition.call(context)).to be
      end

      it 'is false when value is not included' do
        context = Ruy::Context.new([:tuesday, :monday])

        expect(condition.call(context)).to_not be
      end
    end

    context 'when instance receives an attribute' do
      subject(:condition) { Ruy::Conditions::Include.new(:sunday, :days_of_week) }

      it 'is true when value is included' do
        context = Ruy::Context.new({:days_of_week => [:sunday, :monday]})

        expect(condition.call(context)).to be
      end

      it 'is false when value is not included' do
        context = Ruy::Context.new({:days_of_week => [:tuesday, :monday]})

        expect(condition.call(context)).to_not be
      end
    end

  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Include.new(:sunday, :days_of_week) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when condition is the same' do
      let(:other) { Ruy::Conditions::Include.new(:sunday, :days_of_week) }

      it { should eq(other) }
    end

    context 'when condition is different' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when conition has a different attribute' do
      let(:other) { Ruy::Conditions::Include.new(:sunday, :dow) }

      it { should_not eq(other) }
    end

    context 'when condition has a different value' do
      let(:other) { Ruy::Conditions::Include.new(:saturday, :days_of_week) }

      it { should_not eq(other) }
    end

    context 'when condition has no attribute' do
      let(:other) { Ruy::Conditions::Include.new(:sunday) }

      it { should_not eq(other) }
    end

  end
end
