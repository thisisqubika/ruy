require 'spec_helper'

describe Ruy::Conditions::Eq do

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Eq.new(:grade, :a) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::Eq.new(:grade, :a) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Eq.new(:grade, :z) }

      it { should_not eq(other) }
    end
  end
end
