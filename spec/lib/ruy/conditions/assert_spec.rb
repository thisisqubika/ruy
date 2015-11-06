require 'spec_helper'

describe Ruy::Conditions::Assert do

  describe '#call' do
    context 'instance receives no attribute' do
      subject(:condition) { described_class.new }

      it 'is true when context is a truthy value' do
        context = Ruy::Context.new(true)
        expect(condition.call(context)).to be
      end

      it 'is false when context is a falsey value' do
        context = Ruy::Context.new(false)
        expect(condition.call(context)).to_not be
      end
    end

    context 'instance receives an attribute' do
      subject(:condition) { described_class.new(:attr) }

      it 'is true when attribute resolves to a truthy value' do
        context = Ruy::Context.new(attr: true)
        expect(condition.call(context)).to be
      end

      it 'is false when attribute resolves to a falsey value' do
        context = Ruy::Context.new(attr: false)
        expect(condition.call(context)).to_not be
      end
    end
  end

  describe '#==' do
    shared_examples_for 'condition equality' do |*names|
      subject(:condition) { described_class.new(*names) }

      context 'when comparing against self' do
        let(:other) { condition }

        it { should eq(other) }
      end

      context 'when condition has the same attributes' do
        let(:other) { Ruy::Conditions::Assert.new(*names) }

        it { should eq(other) }
      end

      context 'when condition is different' do
        let(:other) { Ruy::Conditions::All.new }

        it { should_not eq(other) }
      end

      context 'when condition has different attributes' do
        let(:other) { Ruy::Conditions::Assert.new(:error) }

        it { should_not eq(other) }
      end
    end

    context 'instance receives no attribute' do
      it_behaves_like 'condition equality'
    end

    context 'instance receives an attribute' do
      it_behaves_like 'condition equality', :attr
    end

  end
end
