require 'spec_helper'

describe Ruy::Conditions::Eq do

  describe '#==' do
    subject(:condition) { Ruy::Conditions::Eq.new(:a, :grade) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::Eq.new(:a, :grade) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::Eq.new(:z, :grade) }

      it { should_not eq(other) }
    end
  end
end
