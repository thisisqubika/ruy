require 'spec_helper'

describe Ruy::Conditions::Cond do

  describe '#call' do
    subject(:condition) do
      Ruy::Conditions::Cond.new.tap do |rule|
        rule.eq :red, :color
        rule.eq 32, :number

        rule.eq :black, :color
        rule.eq 15, :number
      end
    end

    it 'is true when some pair of conditions is met' do
      context = Ruy::Context.new({ :color => :red, :number => 32 })

      expect(condition.call(context)).to be
    end

    it 'is true when another pair of conditions is met' do
      context = Ruy::Context.new({ :color => :black, :number => 15 })

      expect(condition.call(context)).to be
    end

    it 'is false when no pair of conditions is met' do
      context = Ruy::Context.new({ :color => :red, :number => 19 })

      expect(condition.call(context)).to_not be
    end

    context 'when number of conditions is odd' do
      before do
        condition.eq 0, :number
      end

      it 'is true when extra condition is met' do
        context = Ruy::Context.new({ :color => nil, :number => 0 })

        expect(condition.call(context)).to be
      end

      it 'is false when extra condition is not met' do
        context = Ruy::Context.new({ :color => :red, :number => 19 })

        expect(condition.call(context)).to_not be
      end
    end
  end
end
