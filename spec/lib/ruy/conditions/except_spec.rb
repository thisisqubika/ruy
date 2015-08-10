require 'spec_helper'

describe Ruy::Conditions::Except do

  describe '#call' do

    subject(:condition) { Ruy::Conditions::Except.new(false, :enabled) }

    it 'is true when enabled != false' do
      context = Ruy::Context.new({:enabled => true})

      expect(condition.call(context)).to be
    end

    it 'is false when enabled = false' do
      context = Ruy::Context.new({:enabled => false})

      expect(condition.call(context)).to_not be
    end

    context 'when nested conditions' do
      subject(:condition) do
        Ruy::Conditions::Except.new(false, :enabled) do
          assert :success
        end
      end

      it 'is true when !success' do
        context = Ruy::Context.new({:enabled => true, :success => false})

        expect(condition.call(context)).to be
      end

      it 'is false when success' do
        context = Ruy::Context.new({:enabled => true, :success => true})

        expect(condition.call(context)).to_not be
      end

      context 'when no attribute condition' do
        subject(:condition) do
          Ruy::Conditions::Except.new(nil, nil) do
            assert :success
          end
        end

        it 'is true when !success' do
          context = Ruy::Context.new({:enabled => true, :success => false})

          expect(condition.call(context)).to be
        end

        it 'is false when success' do
          context = Ruy::Context.new({:enabled => true, :success => true})

          expect(condition.call(context)).to_not be
        end
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Except.new(false, :enabled) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::Except.new(false, :enabled) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Except.new(true, :disabled) }

      it { should_not eq(other) }
    end
  end
end
