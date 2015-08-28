require 'spec_helper'

describe Ruy::Conditions::Condition do
  subject(:condition) { described_class.new }

  describe '#call' do
    let(:raw_ctx) { Hash.new }

    let(:ctx) { Ruy::Context.new(raw_ctx) }

    it 'returns true when no conditions' do
      expect(condition.call(ctx)).to be(true)
    end

    context 'when conditions' do
      before do
        condition.assert :flag1
        condition.assert :flag2
      end

      it 'returns true when conditions meet' do
        raw_ctx[:flag1] = true
        raw_ctx[:flag2] = true

        expect(condition.call(ctx)).to be(true)
      end

      it 'returns false when some condition does not meet' do
        raw_ctx[:flag1] = true
        raw_ctx[:flag2] = false

        expect(condition.call(ctx)).to be(false)
      end
    end
  end
end
