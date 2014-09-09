require 'spec_helper'

describe Ruy::RuleSet do

  describe 'operator overloading' do
    let(:value) { 'test' }

    describe '#[]' do
      it 'should return the metadata for given key' do
        subject.metadata[:test] = value

        expect(subject[:test]).to be == value
      end

      it 'should return nil if no metadata for given key' do
         expect(subject[:test]).to be_nil
      end
    end

    describe '#[]=' do
      it 'should set the given value to the given key' do
        subject[:test] = value

        expect(subject.metadata[:test]).to be == value
      end
    end

  end
end
