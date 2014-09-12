require 'spec_helper'

describe Ruy::Conditions::LessThanOrEqual do

  describe '#==' do
    subject(:condition) { Ruy::Conditions::LessThanOrEqual.new(:salary, 1_000) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::LessThanOrEqual.new(:salary, 1_000) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::LessThanOrEqual.new(:age, 5) }

      it { should_not eq(other) }
    end
  end
end
