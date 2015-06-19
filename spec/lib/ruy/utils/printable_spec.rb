require 'spec_helper'

require 'pp'
require 'stringio'

describe Ruy::Utils::Printable do

  shared_examples 'an object printer' do
    let(:obj) { klass.new }

    before do
      klass.send(:include, Ruy::Utils::Printable)
    end

    describe '#inspect' do
      it 'does not change #inspect output when redefining #to_s' do
        expect {

          def obj.to_s
            "anonymous"
          end

        }.to_not change(obj, :inspect)
      end
    end

    describe 'pretty print capabilities' do
      it 'does not change pretty print output when defining #to_s' do
        expect {

          def obj.to_s
            "anonymous"
          end

        }.to_not change{ PP.pp(obj, StringIO.new).string }
      end
    end
  end

  context 'when instances have simple values as ivars' do
    let(:klass) do
      Class.new do
        def initialize
          @some_val = :value
        end
      end
    end

    it_behaves_like 'an object printer'
  end

  context 'when instances have arrays as ivars' do
    let(:klass) do
      Class.new do
        def initialize
          @some_array = [1, 2, 3]
        end
      end
    end

    it_behaves_like 'an object printer'
  end

  context 'when instances have hashes as ivars' do
    let(:klass) do
      Class.new do
        def initialize
          @some_hash = { a: 'A', b: 'B' }
        end
      end
    end

    it_behaves_like 'an object printer'
  end

end
