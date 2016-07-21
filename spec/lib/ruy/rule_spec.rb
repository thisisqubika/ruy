require 'spec_helper'

describe Ruy::Rule do
  subject(:rule) do
    rule = Ruy::Rule.new

    rule.assert :flag

    rule.outcome :outcome
    rule.fallback :fallback

    rule
  end

  describe '#set, #get' do
    it 'sets an attribute' do
      rule.set(:name, :value)

      expect(rule.get(:name)).to eq(:value)
    end
  end

  describe '#let' do
    let(:rule) do
      set = Ruy::Rule.new

      set.let :expensive
      set.let :max

      set.greater_than_or_equal 10, :expensive
      set.less_than 100, :expensive

      set
    end

    it 'resolves only once' do
      resolved = 0
      ctx = {
        :expensive => -> { resolved += 1 }
      }

      rule.call(ctx)

      expect(resolved).to eq(1)
    end

    it 'does not resolve unused lets' do
      resolved = false
      ctx = {
        :expensive => -> { 0 },
        :max => -> { resolved = true }
      }

      rule.call(ctx)

      expect(resolved).to_not be
    end
  end

  describe '#call' do
    it 'resolves to outcome when conditions met' do
      result = rule.call(:flag => true)

      expect(result).to eq(:outcome)
    end

    it 'resolves to fallback when conditions do not met' do
      result = rule.call(:flag => false)

      expect(result).to eq(:fallback)
    end
  end

  describe '#to_s' do
    context 'with a full defined rule' do
      let(:rule) do
        rule = Ruy::Rule.new

        rule.instance_exec do
          set :name, 'Full defined rule'

          let :expensive_count
          let :randomness

          eq 'New York', :city

          any do
            between 18..22, :age
            eq true, :enabled
          end

          any do
            between 0, 17, :age
            eq false, :enabled
          end

          belong [:saturday, :sunday], :day_of_week

          every(:car) do
            assert :airbag
            every(:wheels) do
              greater_than 28, :diameter
            end
          end

          some(:cities) do
            eq 'France', :country
            some :partners do
              eq 'Glasgow', :name
            end
          end

          dig(:location, :address) do
            eq '5th Av', :street
          end

          tz('America/New_York') do
            eq '2015-01-01T00:00:00', :timestamp
          end

          outcome 'I matched'

          fallback 'Nothing matched'
        end

        rule
      end

      let(:representation) do
        <<EOS
set :name, "Full defined rule"

let :expensive_count
let :randomness

eq "New York", :city

any do
  between 18..22, :age
  eq true, :enabled
end

any do
  between 0, 17, :age
  eq false, :enabled
end

belong [:saturday, :sunday], :day_of_week

every :car do
  assert :airbag
  every :wheels do
    greater_than 28, :diameter
  end
end

some :cities do
  eq "France", :country
  some :partners do
    eq "Glasgow", :name
  end
end

dig :location, :address do
  eq "5th Av", :street
end

tz "America/New_York" do
  eq "2015-01-01T00:00:00", :timestamp
end

outcome "I matched"

fallback "Nothing matched"
EOS
      end

      it 'matches the expected representation' do
        expect(rule.to_s).to eq(representation)
      end
    end

    context 'with a rule that only has a fallback' do
      let(:rule) do
        rule = Ruy::Rule.new

        rule.fallback 'Nothing matched'
        rule
      end

      let(:representation) do
        <<EOS
fallback "Nothing matched"
EOS
      end

      it 'matches the expected representation' do
        expect(rule.to_s).to eq(representation)
      end
    end

    context 'with a rule that only has an outcome' do
      let(:rule) do
        rule = Ruy::Rule.new

        rule.outcome 'It matched' do
          eq true, :enabled
        end

        rule
      end

      let(:representation) do
        <<EOS
outcome "It matched" do
  eq true, :enabled
end
EOS
      end

      it 'matches the expected representation' do
        expect(rule.to_s).to eq(representation)
      end
    end
  end
end
