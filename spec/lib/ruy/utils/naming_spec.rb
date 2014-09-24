require 'spec_helper'

require 'net/http'
require 'ruy/conditions/assert'

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

  describe '.snakecase' do
    it 'converts a camelized string into snake case' do
      result = utils.snakecase('GreaterThanOrEqual')

      expect(result).to eq('greater_than_or_equal')
    end

    it 'converts an all caps string into snake case' do
      result = utils.snakecase('HTTP_REQUEST')

      expect(result).to eq('http_request')
    end

    it 'handles all caps acronyms' do
      result = utils.snakecase('UpgradedHTTP')

      expect(result).to eq('upgraded_http')
    end
  end

  describe '.rule_name' do
    it 'returns the name of the rule' do
      name = utils.rule_name(Ruy::Conditions::Assert.new(:flag))

      expect(name).to eq('assert')
    end
  end
end
