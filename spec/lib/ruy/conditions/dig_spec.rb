# encoding: UTF-8

require 'spec_helper'

describe Ruy::Conditions::Dig do

  describe '#call' do
    subject(:condition) do
      Ruy::Conditions::Dig.new(:location).tap do |rule|
        rule.assert :address
        rule.assert :city
      end
    end

    context 'when subcontext meets all the nested conditions' do
      let(:profile) do
        {
          location: { address: 'Les Champs-Élysées', city: 'Paris' }
        }
      end

      it 'is true' do
        context = Ruy::Context.new(profile)

        expect(condition.call(context)).to be
      end
    end

    context 'when subcontext does not meet all the nested conditions' do
      let(:without_city) do
        {
          location: { address: 'Les Champs-Élysées' }
        }
      end

      it 'is false' do
        context = Ruy::Context.new(without_city)

        expect(condition.call(context)).to_not be
      end
    end

    context 'when subcontext is missing' do
      let(:plain_profile) do
        { serial_number: 'AX-1234' }
      end

      it 'is false' do
        context = Ruy::Context.new(plain_profile)

        expect(condition.call(context)).to_not be
      end
    end

    context 'when empty condition' do
      subject(:condition) do
        Ruy::Conditions::Dig.new(:location)
      end

      let(:profile) do
        {
          location: {}
        }
      end

      it 'is true' do
        context = Ruy::Context.new(profile)

        expect(condition.call(context)).to be
      end

      context 'when nil subcontext' do
        let(:profile) do
          { location: nil }
        end

        it 'is true' do
          context = Ruy::Context.new(profile)

          expect(condition.call(context)).to be
        end
      end

      context 'when subcontext is missing' do
        let(:profile) do
          { serial_number: 'AX-1234' }
        end

        it 'is false' do
          context = Ruy::Context.new(profile)

          expect(condition.call(context)).to_not be
        end
      end
    end

    context 'when digging deeper' do
      subject(:condition) do
        Ruy::Conditions::Dig.new(:location).tap do |rule|
          rule.dig :address do
            eq '5th Av', :street
          end
        end
      end

      let(:profile) do
        { location: { address: { street: '5th Av' } } }
      end

      it 'evaluates the whole hierarchy of conditions' do
        context = Ruy::Context.new(profile)

        expect(condition.call(context)).to be
      end

      context 'when subcontext is missing' do
        let(:profile) do
          { location: { city: 'Paris' } }
        end

        it 'is false' do
          context = Ruy::Context.new(profile)

          expect(condition.call(context)).to_not be
        end
      end
    end

    context 'when multiple attributes' do
      subject(:condition) do
        Ruy::Conditions::Dig.new(:location, :address).tap do |rule|
          rule.eq '5th Av', :street
        end
      end

      it 'digs' do
        profile = { location: { address: { street: '5th Av' } } }

        context = Ruy::Context.new(profile)

        expect(condition.call(context)).to be
      end
    end
  end


  describe '#==' do
    subject(:condition) { Ruy::Conditions::Dig.new(:a, :b) }

    before do
      condition.conditions << Ruy::Conditions::Assert.new(:c1)
    end

    context 'when comparing against self' do
      let(:other) { condition }

      it { should eq(other) }
    end

    context 'when same sub-conditions' do
      let(:other) { Ruy::Conditions::Dig.new(:a, :b) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should eq(other) }
    end

    context 'when same sub-conditions but different attributes' do
      let(:other) { Ruy::Conditions::Dig.new(:y, :z) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should_not eq(other) }
    end

    context 'when same sub-conditions but different rule' do
      let(:other) { Ruy::Conditions::All.new }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c1)
      end

      it { should_not eq(other) }
    end

    context 'when sub-conditions are different' do
      let(:other) { Ruy::Conditions::Dig.new(:a, :b) }

      before do
        other.conditions << Ruy::Conditions::Assert.new(:c99)
      end

      it { should_not eq(other) }
    end
  end
end
