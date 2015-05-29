require 'spec_helper'

describe Ruy::Conditions::Between do

  describe '#call' do

    subject(:condition) { Ruy::Conditions::Between.new(:age, 0, 17) }

    it 'is true when in range' do
      context = Ruy::Context.new({:age => 10})

      expect(condition.call(context)).to be
    end

    it 'is false when out of range' do
      context = Ruy::Context.new({:age => 18})

      expect(condition.call(context)).to_not be
    end

    context 'when nested conditions' do
      subject(:condition) do
        Ruy::Conditions::Between.new(:age, 0, 17) do
          assert :success
        end
      end

      it 'is true when nested succeeds' do
        context = Ruy::Context.new({:age => 10, :success => true})

        expect(condition.call(context)).to be
      end

      it 'is false when nested fails' do
        context = Ruy::Context.new({:age => 10, :success => false})

        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Between.new(:age, 0, 17) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::Between.new(:age, 0, 17) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Between.new(:salary, -1_000, 0) }

      it { should_not eq(other) }
    end

  end
end
