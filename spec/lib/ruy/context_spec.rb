require 'spec_helper'

describe Ruy::Context do
  subject { described_class.new(ctx) }

  describe '#resolve' do
    let(:ctx) { {attr: 'value'} }

    context 'when attribute is present in hash' do
      it 'returns the expected value' do
        expect(subject.resolve(:attr)).to eq('value')
      end
    end

    context 'when attribute is not present in hash' do
      it 'returns nil' do
        expect(subject.resolve(:non_existent_attribute)).to be_nil
      end
    end

    context 'when attribute is present in hash as a string' do
      let(:ctx) { {'attr' => 'value'} }

      it 'returns the expected value' do
        expect(subject.resolve(:attr)).to eq('value')
      end
    end

    pending 'when attribute references a lazy variable'

  end
end
