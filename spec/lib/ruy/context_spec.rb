require 'spec_helper'

describe Ruy::Context do
  subject { described_class.new(ctx) }

  describe '#include?' do
    let(:ctx) { {attr: 'value'} }

    context 'when attribute is present in hash' do
      it 'is true' do
        expect(subject.include?(:attr)).to be true
      end
    end

    context 'when attribute is not present in hash' do
      it 'is false' do
        expect(subject.include?(:non_existent_attribute)).to be false
      end
    end

    context 'when attribute is present in hash as a string' do
      let(:ctx) { {'attr' => 'value'} }

      it 'is true' do
        expect(subject.include?(:attr)).to be true
      end
    end

    describe 'lazy attributes lookup' do
      subject { described_class.new(ctx, [:lazy]) }

      context 'when looked up lazy attribute is defined' do
        it 'is true' do
          expect(subject.include?(:lazy)).to be true
        end
      end

      context 'when looked up lazy attribute is not defined' do
        it 'is false' do
          expect(subject.include?(:eager)).to be false
        end
      end
    end
  end

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
