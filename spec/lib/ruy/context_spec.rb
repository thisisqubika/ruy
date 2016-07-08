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

    context 'when attribute references a lazy variable' do
      let(:ctx) { {:lazy => -> { Array.new } } }

      subject { described_class.new(ctx, [:lazy]) }

      it 'returns the expected value' do
        expect(subject.resolve(:lazy)).to be_kind_of(Array)
      end

      it 'caches the result' do
        ary = subject.resolve(:lazy)
        expect(subject.resolve(:lazy)).to be(ary)
      end

      context 'and key is not in the context' do
        let(:ctx) { {:other_key => 1} }

        it 'returns nil' do
          expect(subject.resolve(:key)).to be_nil
        end
      end

    end

  end
end
