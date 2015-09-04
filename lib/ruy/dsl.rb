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
    def assert(attr)
      self.conditions << Conditions::Assert.new(attr)
    end

    # Adds a Between condition.
    #
    # @param (see Conditions::Between#initialize)
    def between(from, to, attr, &block)
      self.conditions << Conditions::Between.new(from, to, attr, &block)
    end

    # Adds an Eq condition.
    #
    # @param (see Conditions::Eq#initialize)
    def eq(value, attr, &block)
      self.conditions << Conditions::Eq.new(value, attr, &block)
    end

    # Adds a Cond condition.
    #
    # @yield Evaluates the given block in the context of the new rule
    def cond(&block)
      cond = Conditions::Cond.new
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
    def greater_than(value, attr)
      self.conditions << Conditions::GreaterThan.new(value, attr)
    end

    # Adds a GreaterThanOrEqual condition.
    #
    # @param (see Conditions::GreaterThanOrEqual#initialize)
    def greater_than_or_equal(value, attr)
      self.conditions << Conditions::GreaterThanOrEqual.new(value, attr)
    end

    # Adds an In condition.
    #
    # @param (see Conditions::Include#initialize)
    def in(values, attr, &block)
      self.conditions << Conditions::In.new(values, attr, &block)
    end

    # Adds a InCyclicOrder condition.
    #
    # @param (see Conditions::InCyclicOrder#initialize)
    def in_cyclic_order(from, to, attr, &block)
      self.conditions << Conditions::InCyclicOrder.new(from, to, attr, &block)
    end

    # Adds an Include condition.
    #
    # @param (see Conditions::Included#initialize)
    def include(value, attr, &block)
      self.conditions << Conditions::Include.new(value, attr, &block)
    end

    # Adds a LessOrEqualThan condition.
    #
    # @param (see Conditions::LessOrEqualThan#initialize)
    def less_than_or_equal(value, attr, &block)
      self.conditions << Conditions::LessThanOrEqual.new(value, attr)
    end

    # Adds a LessThan condition.
    #
    # @param (see Conditions::LessThan#initialize)
    def less_than(value, attr)
      self.conditions << Conditions::LessThan.new(value, attr)
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
