require 'spec_helper'

describe Ruy::Conditions::LessThan do

  describe '#==' do
    subject(:condition) { Ruy::Conditions::LessThan.new(1_000, :salary) }

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same condition values' do
      let(:other) { Ruy::Conditions::LessThan.new(1_000, :salary) }

      it { should eq(other) }
    end

    context 'when different rule' do
      let(:other) { Ruy::Conditions::All.new }

      it { should_not eq(other) }
    end

    context 'when different values' do
      let(:other) { Ruy::Conditions::LessThan.new(5, :age) }

      it { should_not eq(other) }
    end
  end
end
