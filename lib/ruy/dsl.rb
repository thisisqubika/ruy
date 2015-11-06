module Ruy
  module DSL

    # Adds an All condition.
    #
    # @yield Evaluates the given block in the context of the new rule
    def all(&block)
      cond = Conditions::All.new
      cond.instance_exec(&block)

      self.conditions << cond
    end

    # Adds an Any condition.
    #
    # @yield Evaluates the given block in the context of the new rule
    def any(&block)
      cond = Conditions::Any.new
      cond.instance_exec(&block)

      self.conditions << cond
    end

    # Adds an Assert condition.
    #
    # @param (see Conditions::Assert#initialize)
    def assert(*attrs)
      self.conditions << Conditions::Assert.new(*attrs)
    end

    # Adds a Between condition.
    #
    # @param (see Conditions::Between#initialize)
    def between(from, to, *attrs)
      self.conditions << Conditions::Between.new(from, to, *attrs)
    end

    # Adds a Cond condition.
    #
    # @yield Evaluates the given block in the context of the new rule
    def cond(&block)
      cond = Conditions::Cond.new
      cond.instance_exec(&block)

      self.conditions << cond
    end

    # Adds an Eq condition.
    #
    # @param (see Conditions::Eq#initialize)
    def eq(value, *attrs)
      self.conditions << Conditions::Eq.new(value, *attrs)
    end

    # Adds an Every condition.
    #
    # @param (see Conditions::Every#initialize)
    def every(*attrs, &block)
      cond = Conditions::Every.new(*attrs)
      cond.instance_exec(&block)

      self.conditions << cond
    end

    # Adds an Except condition.
    #
    # @param (see Conditions::Except#initialize)
    def except(&block)
      self.conditions << Conditions::Except.new(&block)
    end

    # Adds a GreaterThan condition.
    #
    # @param (see Conditions::GreaterThanOrEqual#initialize)
    def greater_than(value, *attrs)
      self.conditions << Conditions::GreaterThan.new(value, *attrs)
    end

    # Adds a GreaterThanOrEqual condition.
    #
    # @param (see Conditions::GreaterThanOrEqual#initialize)
    def greater_than_or_equal(value, *attrs)
      self.conditions << Conditions::GreaterThanOrEqual.new(value, *attrs)
    end

    # Adds an In condition.
    #
    # @param (see Conditions::Include#initialize)
    def in(values, *attrs)
      self.conditions << Conditions::In.new(values, *attrs)
    end

    # Adds a InCyclicOrder condition.
    #
    # @param (see Conditions::InCyclicOrder#initialize)
    def in_cyclic_order(from, to, *attrs)
      self.conditions << Conditions::InCyclicOrder.new(from, to, *attrs)
    end

    # Adds an Include condition.
    #
    # @param (see Conditions::Included#initialize)
    def include(value, *attrs)
      self.conditions << Conditions::Include.new(value, *attrs)
    end

    # Adds a LessThan condition.
    #
    # @param (see Conditions::LessThan#initialize)
    def less_than(value, *attrs)
      self.conditions << Conditions::LessThan.new(value, *attrs)
    end

    # Adds a LessOrEqualThan condition.
    #
    # @param (see Conditions::LessOrEqualThan#initialize)
    def less_than_or_equal(value, *attrs)
      self.conditions << Conditions::LessThanOrEqual.new(value, *attrs)
    end

    # Adds a Some condition.
    #
    # @param (see Conditions::Some#initialize)
    def some(*attrs, &block)
      cond = Conditions::Some.new(*attrs)
      cond.instance_exec(&block)

      self.conditions << cond
    end

    # Adds a TZ condition block
    #
    # @param [String] tz_identifier String representing IANA's
    #   time zone identifier. Defaults to UTC if none passed.
    # @yield Evaluates the given block in the context of the TZ rule
    def tz(tz_identifier = 'UTC', &block)
      cond = Conditions::TZ.new(tz_identifier)
      cond.instance_exec(&block)

      self.conditions << cond
    end

    # @param [Integer] indentation Indentation level
    def to_s(indentation = 0)
      rule_name = Ruy::Utils::Naming.rule_name(self)

      s = Ruy::Utils::Printable.indent(indentation) << rule_name

      if self.params.any?
        stringified_params = self.params.map(&:inspect)

        s << ' ' << stringified_params.join(', ')
      end

      if !self.respond_to?(:conditions) || self.conditions.empty?
        s << "\n"
      else
        s << " do\n"
        s << self.conditions.map { |c| c.to_s(indentation + 1) }.join()
        s << Ruy::Utils::Printable.indent(indentation) + "end\n"
      end

      s
    end
  end
end
