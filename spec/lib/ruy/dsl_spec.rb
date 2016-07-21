require 'spec_helper'

describe Ruy::DSL do
  let(:host) do
    klass = Class.new do
      include Ruy::DSL

      def conditions
        @conditions ||= []
      end
    end

    klass.new
  end

  describe '#all' do
    it 'adds an All condition' do
      host.all {
        between 0, 1, :age
        eq true, :bofh
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::All))
    end
  end

  describe '#any' do
    it 'adds an Any condition' do
      host.any {
        between 0, 1, :age
        eq true, :bofh
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::Any))
    end
  end

  describe '#assert' do
    it 'adds an Assert condition' do
      host.assert(:success)

      expect(host.conditions).to include(be_a(Ruy::Conditions::Assert))
    end

    context 'calling without an attribute' do
      it 'adds an Assert condition' do
        host.assert
        expect(host.conditions).to include(be_a(Ruy::Conditions::Assert))
      end
    end
  end

  describe '#belong' do
    it 'adds a Belong condition' do
      host.belong([:white, :blue, :red], :color)

      expect(host.conditions).to include(be_a(Ruy::Conditions::Belong))
    end
  end

  describe '#between' do
    it 'adds a Between condition' do
      host.between(1900, 2000, :year_of_birth)

      expect(host.conditions).to include(be_a(Ruy::Conditions::Between))
    end

    context 'calling without an attribute' do
      it 'adds a Between condition' do
        host.between(1900, 2000)
        expect(host.conditions).to include(be_a(Ruy::Conditions::Between))
      end
    end
  end

  describe '#cond' do
    it 'adds a Cond condition' do
      host.cond {
        eq 'rule', :rule
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::Cond))
    end
  end

  describe '#dig' do
    it 'adds a Dig condition' do
      host.dig(:location) {
        assert :address
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::Dig))
    end
  end

  describe '#eq' do
    it 'adds an Eq condition' do
      host.eq(:warm, :zone)

      expect(host.conditions).to include(be_a(Ruy::Conditions::Eq))
    end

    context 'calling without an attribute' do
      it 'adds a Eq condition' do
        host.eq(:warm)
        expect(host.conditions).to include(be_a(Ruy::Conditions::Eq))
      end
    end
  end

  describe '#every' do
    it 'adds an Every condition' do
      host.every(:person) {
        between 0, 1, :age
        eq true, :bofh
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::Every))
    end

    context 'calling without an attribute' do
      it 'adds an Every condition' do
        host.every do
          between 0, 1, :age
          eq true, :bofh
        end

        expect(host.conditions).to include(be_a(Ruy::Conditions::Every))
      end
    end
  end

  describe '#except' do
    it 'adds an Except condition' do
      host.except

      expect(host.conditions).to include(be_a(Ruy::Conditions::Except))
    end
  end

  describe '#greater_than' do
    it 'adds a GreaterThan condition' do
      host.greater_than(18, :age)

      expect(host.conditions).to include(be_a(Ruy::Conditions::GreaterThan))
    end

    context 'calling without an attribute' do
      it 'adds a GreaterThan condition' do
        host.greater_than(18)
        expect(host.conditions).to include(be_a(Ruy::Conditions::GreaterThan))
      end
    end
  end

  describe '#greater_than_or_equal' do
    it 'adds a GreaterThanOrEqual condition' do
      host.greater_than_or_equal(18, :age)

      expect(host.conditions).to include(be_a(Ruy::Conditions::GreaterThanOrEqual))
    end

    context 'calling without an attribute' do
      it 'adds a GreaterThanOrEqual condition' do
        host.greater_than_or_equal(18)
        expect(host.conditions).to include(be_a(Ruy::Conditions::GreaterThanOrEqual))
      end
    end
  end

  describe '#in_cyclic_order' do
    it 'adds a InCyclicOrder condition' do
      host.in_cyclic_order(23, 5, :work_hours)

      expect(host.conditions).to include(be_a(Ruy::Conditions::InCyclicOrder))
    end
  end

  describe '#include' do
    it 'adds an Include condition' do
      host.include(:colors, :white)

      expect(host.conditions).to include(be_a(Ruy::Conditions::Include))
    end
  end

  describe '#less_than' do
    it 'adds a LessThan condition' do
      host.less_than(18, :age)

      expect(host.conditions).to include(be_a(Ruy::Conditions::LessThan))
    end

    context 'calling without an attribute' do
      it 'adds a LessThan condition' do
        host.less_than(18)
        expect(host.conditions).to include(be_a(Ruy::Conditions::LessThan))
      end
    end
  end

  describe '#less_than_or_equal' do
    it 'adds a LessThanOrEqual condition' do
      host.less_than_or_equal(17, :age)

      expect(host.conditions).to include(be_a(Ruy::Conditions::LessThanOrEqual))
    end

    context 'calling without an attribute' do
      it 'adds a LessThanOrEqual condition' do
        host.less_than_or_equal(17)
        expect(host.conditions).to include(be_a(Ruy::Conditions::LessThanOrEqual))
      end
    end
  end

  describe '#some' do
    it 'adds a Some condition' do
      host.some(:person) {
        between 0, 1, :age
        eq true, :bofh
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::Some))
    end

    context 'calling without an attribute' do
      it 'adds a LessThanOrEqual condition' do
        host.some do
          between 0, 1, :age
          eq true, :bofh
        end

        expect(host.conditions).to include(be_a(Ruy::Conditions::Some))
      end
    end
  end

  describe '#tz' do
    it 'adds a TZ condition' do
      host.tz {
        between '2014-12-31T23:00:00', '2015-01-01T01:00:00', :timestamp
        eq '2015-01-01T00:00:00', :timestamp
        all do
          eq 18, :age
        end
      }

      expect(host.conditions).to include(be_a(Ruy::Conditions::TZ))
    end
  end

end
