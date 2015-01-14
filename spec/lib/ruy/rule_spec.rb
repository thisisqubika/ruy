require 'spec_helper'

describe Ruy::Rule do
  subject(:rule) { Ruy::Rule.new }

  describe '#all' do
    it 'adds an All condition' do
      rule.all {
        between :age, 0, 1
        eq :bofh, true
      }

      expect(rule.conditions).to include(be_a(Ruy::Conditions::All))
    end
  end

  describe '#any' do
    it 'adds an Any condition' do
      rule.any {
        between :age, 0, 1
        eq :bofh, true
      }

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Any))
    end
  end

  describe '#assert' do
    it 'adds an Assert condition' do
      rule.assert(:success)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Assert))
    end
  end

  describe '#between' do
    it 'adds a Between condition' do
      rule.between(:year_of_birth, 1900, 2000)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Between))
    end
  end

  describe '#cond' do
    it 'adds a Cond condition' do
      rule.cond {
        eq :rule, 'rule'
      }

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Cond))
    end
  end

  describe '#eq' do
    it 'adds an Eq condition' do
      rule.eq(:zone, :warm)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Eq))
    end
  end

  describe '#except' do
    it 'adds an Except condition' do
      rule.except(:enabled, false)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Except))
    end
  end

  describe '#greater_than_or_equal' do
    it 'adds a GreaterThanOrEqual condition' do
      rule.greater_than_or_equal(:age, 18)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::GreaterThanOrEqual))
    end
  end

  describe '#include' do
    it 'adds an Include condition' do
      rule.include(:color, [:white, :blue, :red])

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Include))
    end
  end

  describe '#included' do
    it 'adds an Included condition' do
      rule.included(:colors, :white)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::Included))
    end
  end

  describe '#less_than_or_equal' do
    it 'adds a LessThanOrEqual condition' do
      rule.less_than_or_equal(:age, 17)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::LessThanOrEqual))
    end
  end

  describe '#less_than' do
    it 'adds a LessThan condition' do
      rule.less_than(:age, 18)

      expect(rule.conditions).to include(be_a(Ruy::Conditions::LessThan))
    end
  end

  describe '#tz' do
    it 'adds a TZ condition' do
      rule.tz {
        between :timestamp, '2014-12-31T23:00:00', '2015-01-01T01:00:00'
        eq :timestamp, '2015-01-01T00:00:00'
        all do
          eq :age, 18
        end
      }

      expect(rule.conditions).to include(be_a(Ruy::Conditions::TZ))
    end
  end

  describe '#set, #get' do
    it 'sets an attribute' do
      rule.set(:name, :value)

      expect(rule.get(:name)).to eq(:value)
    end
  end

  describe '#var' do
    context 'with value' do
      before do
        rule.var(:foo, :bar)
      end

      it 'defines a variable' do
        expect(rule.vars).to include(:foo)
      end

      it 'assigns the variable to a callable that evaluates to the given value' do
        callable = rule.vars[:foo]

        expect(callable.call).to eq(:bar)
      end
    end

    context 'when block' do
      before do
        rule.var(:foo) { :bar }
      end

      it 'defines a variable' do
        expect(rule.vars).to include(:foo)
      end

      it 'assigns the variable to the given block' do
        callable = rule.vars[:foo]

        expect(callable.call).to eq(:bar)
      end
    end
  end

  describe '#==' do
    let(:other) { Ruy::Rule.new }

    before do
      rule.conditions << :c1
      rule.var :v1, 'v1'

      other.conditions << :c1
      other.var :v1, 'v1'
    end

    it 'is true when comparing with itself' do
      expect(rule).to eq(rule)
    end

    context 'when other rule has same conditions and vars' do

      it 'is true' do
        expect(rule).to eq(other)
      end
    end

    context 'when different set of conditions' do
      it 'is false' do
        other.conditions << :c2

        expect(rule).to_not eq(other)
      end
    end

    context 'when different set of variables' do
      it 'is false' do
        other.var :v2, 'v2'

        expect(rule).to_not eq(other)
      end
    end
  end

  describe '#call' do
    it 'returns true when no conditions' do
      ctx = double(:context)

      expect(subject.call(ctx)).to be
    end

    it 'should return false if attributes are not available in context' do
      rule.all {
        eq :invalid_attr, 20
      }

      expect(rule.call(Ruy::VariableContext.new({}, {}))).to be(false)
    end
  end

  describe '#to_s' do
    let(:rule) do
      between = Ruy::Conditions::Between.new(:age, 18, 22) do
        eq :flag, true
        greater_than_or_equal :height, 1.8
      end
    end

    let(:representation) do
      <<EOS
between :age, 18, 22 do
  eq :flag, true
  greater_than_or_equal :height, 1.8
end
EOS
    end

    it 'matches the expected representation' do
      expect(rule.to_s).to eq(representation)
    end
  end

end
