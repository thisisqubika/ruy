require 'spec_helper'

describe Ruy::Conditions::Include do

  describe '#call' do

    subject(:condition) { Ruy::Conditions::Include.new(:sunday, :days_of_week) }

    it 'is true when includes' do
      context = Ruy::Context.new({:days_of_week => [:sunday, :monday]})

      expect(condition.call(context)).to be
    end

    it 'is false when not includes' do
      context = Ruy::Context.new({:days_of_week => [:tuesday, :monday]})

      expect(condition.call(context)).to_not be
    end

    context 'when nested conditions' do
      subject(:condition) do
        Ruy::Conditions::Include.new(:tuesday, :days_of_week) do
          assert :success
        end
      end

      it 'is true when nested succeeds' do
        context = Ruy::Context.new({:days_of_week => [:tuesday], :success => true})

        expect(condition.call(context)).to be
      end

      it 'is false when nested fails' do
        context = Ruy::Context.new({:days_of_week => [:sunday], :success => false})

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

    context 'when same condition' do
      let(:other) { Ruy::Conditions::Include.new(:sunday, :days_of_week) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different attribute' do
      let(:other) { Ruy::Conditions::Include.new(:sunday, :dow) }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Include.new(:saturday, :days_of_week) }

      it { should_not eq(other) }
    end

  end
end
