require 'spec_helper'

describe Ruy::Conditions::Any do

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Any.new }

    before do
      condition.conditions << :c1
    end

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same sub-conditions' do
      let(:other) { Ruy::Conditions::Any.new }

      before do
        other.conditions << :c1
      end

      it { should eq(other) }
    end

    context 'when same sub-conditions but different rule' do
      let(:other) { Ruy::Conditions::All.new }

      before do
        other.conditions << :c1
      end

      it { should_not eq(other) }
    end

    context 'when sub-conditions are different' do
      let(:other) { Ruy::Conditions::Any.new }

      before do
        other.conditions << :c99
      end

      it { should_not eq(other) }
    end
  end
end
