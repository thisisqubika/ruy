require 'spec_helper'

describe Ruy::Conditions::Eq do

  describe '#call' do
    context 'instance receives no attribute' do
      subject(:condition) { described_class.new('Montevideo') }

      it 'is true when context is equal' do
        context = Ruy::Context.new('Montevideo')
        expect(condition.call(context)).to be
      end

      it 'is false when context is not equal' do
        context = Ruy::Context.new('Buenos Aires')
        expect(condition.call(context)).to_not be
      end
    end

    context 'instance receives an attribute' do
      subject(:condition) { described_class.new('Montevideo', :city) }

      it 'is true when attributes resolves to an equal value' do
        context = Ruy::Context.new(city: 'Montevideo')
        expect(condition.call(context)).to be
      end

      it 'is false when attributes resolves to a non-equal value' do
        context = Ruy::Context.new(city: 'Buenos Aires')
        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    shared_examples_for 'condition equality' do |*attrs|
      subject(:condition) { Ruy::Conditions::Eq.new(:a, *attrs) }

      context 'when comparing against self' do
        let(:other) { condition }

        it { should eq(other) }
      end

      context 'when rule has same condition values' do
        let(:other) { Ruy::Conditions::Eq.new(:a, *attrs) }

        it { should eq(other) }
      end

      context 'when rule is different' do
        let(:other) { Ruy::Conditions::All.new }

        it { should_not eq(other) }
      end

      context 'when rule has different values' do
        let(:other) { Ruy::Conditions::Eq.new(:z, *attrs) }

        it { should_not eq(other) }
      end
    end

    context 'instance receives no attribute' do
      it_behaves_like 'condition equality'
    end

    context 'instance receives an attribute' do
      it_behaves_like 'condition equality', :var
    end
  end
end
