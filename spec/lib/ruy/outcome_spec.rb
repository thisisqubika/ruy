require 'spec_helper'

describe Ruy::Outcome do
  describe '#==' do
    subject(:outcome) { Ruy::Outcome.new(:success) }

    context 'when comparing against self' do
      let(:other) { outcome }

      it { should eq(other) }
    end

    context 'when same outcome value and conditions' do
      let(:other) { Ruy::Outcome.new(:success) }

      it { should eq(other) }
    end

    context 'when different outcome value' do
      let(:other) { Ruy::Outcome.new(:error) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should_not eq(other) }
    end

    context 'when different conditions' do
      let(:other) { Ruy::Outcome.new(:success) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c9)
      end

      it { should_not eq(other) }
    end
  end
end
