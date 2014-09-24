require 'spec_helper'

require 'net/http'

describe Ruy::Utils::Naming do

  subject(:utils) { Ruy::Utils::Naming }

  describe '.simple_module_name' do
    it 'is the name of the class' do
      simple_name = utils.simple_module_name(String)

      expect(simple_name).to eq('String')
    end

    it 'is the name of the leaf module' do
      simple_name = utils.simple_module_name(Net::HTTP)

      expect(simple_name).to eq('HTTP')
    end

    it 'is nil for an anonymous class' do
      simple_name = utils.simple_module_name(Class.new)

      expect(simple_name).to be_nil
    end
  end

end
