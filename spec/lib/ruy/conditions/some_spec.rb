require 'spec_helper'

describe Ruy::Conditions::Some do

  describe '#call' do
    subject(:condition) do
      Ruy::Conditions::Some.new(:cities).tap do |rule|
        rule.eq 'France', :country
        rule.greater_than 500, :population
      end
    end

    let(:paris) do
      { :country => 'France', :population => 2_200 }
    end

    let(:marseille) do
      { :country => 'France', :population => 800 }
    end

    context 'when all members meet all the conditions' do
      it 'is true' do
        context = Ruy::Context.new(:cities => [paris, marseille])

        expect(condition.call(context)).to be
      end
    end

    context 'when some members meet all the conditions' do
      before { marseille[:population] = 0 }

      it 'is true' do
        context = Ruy::Context.new(:cities => [paris, marseille])

        expect(condition.call(context)).to be
      end
    end

    context 'when there is no member that meets all the conditions' do
      before do
        paris[:population] = 0
        marseille[:population] = 0
      end

      it 'is false' do
        context = Ruy::Context.new(:cities => [paris, marseille])

        expect(condition.call(context)).to_not be
      end
    end

    context 'when empty enumerable' do
      it 'is false' do
        context = Ruy::Context.new(:cities => [])

        expect(condition.call(context)).to_not be
      end
    end

    context 'when `some` rule is nested' do
      subject(:condition) do
        Ruy::Conditions::Some.new(:cities).tap do |rule|
          rule.eq 'France', :country

          rule.some(:partners) do
            eq 'Glasgow', :name
          end
        end
      end

      let(:marseille) do
        { :country => 'France', :partners => [{ :name => 'Glasgow' }, { :name => 'Hamburg' }] }
      end

      let(:paris) do
        { :country => 'France', :partners => [{ :name => 'Prague' }, { :name => 'Tokyo' }] }
      end

      context 'when at least one member meets the nested `some` conditions' do
        it 'is true' do
          context = Ruy::Context.new(:cities => [marseille])

          expect(condition.call(context)).to be
        end
      end

      context 'when no member meets the nested `some` conditions' do
        it 'is false' do
          context = Ruy::Context.new(:cities => [paris])

          expect(condition.call(context)).to_not be
        end
      end
    end
  end

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Some.new(:attr) }

    before do
      condition.conditions << Ruy::Conditions::Assert.new(:c1)
    end

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same sub-conditions' do
      let(:other) { Ruy::Conditions::Some.new(:attr) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should eq(other) }
    end

    context 'when same sub-conditions but different attribute' do
      let(:other) { Ruy::Conditions::Some.new(:attr2) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should_not eq(other) }
    end

    context 'when same sub-conditions but different rule' do
      let(:other) { Ruy::Conditions::All.new }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should_not eq(other) }
    end

    context 'when sub-conditions are different' do
      let(:other) { Ruy::Conditions::Some.new(:attr) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c99)
      end

      it { should_not eq(other) }
    end
  end
end
