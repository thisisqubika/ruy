module Ruy

  # Returns a constant using a qualified constant name string
  #
  # @param [String] name
  # @return [Object]
  def self.qualified_const_get(name)
    root = Object
    name.split('::').each do |klass|
      root = root.const_get(klass)
    end

    root
  end

  # A rule is a set of conditions
  class Rule

    attr_reader :conditions
    attr_reader :vars

    def initialize
      @conditions = []
      @vars = {}
      @attrs = {}
      @params = []
    end

    # Serialize a rule object as a hash
    #
    # @return [Hash]
    def to_hash
      ret = { node: self.class.name, params: params }
      ret[:conditions] = @conditions.map(&:to_hash) if @conditions.any?

      ret
    end

    # Look to the given keys, and load the rule nodes in their values
    #
    # @param [Array<Symbol>] keys
    # @param [Hash] hash
    # @return [Ruy::Rule]
    def load_rule_objects_from(hash, *keys)
      keys.each do |key|
        if hash.has_key?(key)
          hash[key].each { |o| self.send(key) << Ruy::Rule.from_hash(o) }
        end
      end

      self
    end

    # Load a new rule from its hash representation
    #
    # @param [Hash] hash
    # @return [Ruy::Rule]
    def self.from_hash(hash)
      rule = Ruy.qualified_const_get(hash[:node]).new(*hash[:params])
      rule.load_rule_objects_from(hash, :conditions, :outcomes)
    end

    # Adds an All condition.
    #
    # @yield Evaluates the given block in the context of the current rule
    def all(&block)
      cond = Conditions::All.new
      cond.instance_exec(&block)

      @conditions << cond
    end

    # Adds an Any condition.
    #
    # @yield Evaluates the given block in the context of the current rule
    def any(&block)
      cond = Conditions::Any.new
      cond.instance_exec(&block)

      @conditions << cond
    end

    # Adds an Assert condition.
    #
    # @param (see Conditions::Assert#initialize)
    def assert(attr)
      @conditions << Conditions::Assert.new(attr)
    end

    # Adds a Between condition.
    #
    # @param (see Conditions::Between#initialize)
    def between(attr, from, to, &block)
      @conditions << Conditions::Between.new(attr, from, to, &block)
    end

    # Adds an Eq condition.
    #
    # @param (see Conditions::Eq#initialize)
    def eq(attr, value, &block)
      @conditions << Conditions::Eq.new(attr, value, &block)
    end

    # Adds a Cond condition.
    #
    # @yield Evaluates the given block in the context of the current rule
    def cond(&block)
      cond = Conditions::Cond.new
      cond.instance_exec(&block)

      @conditions << cond
    end

    # Adds an Except condition.
    #
    # @param (see Conditions::Except#initialize)
    def except(attr = nil, value = nil, &block)
      @conditions << Conditions::Except.new(attr, value, &block)
    end

    # Adds a GreaterThanOrEqual condition.
    #
    # @param (see Conditions::GreaterThanOrEqual#initialize)
    def greater_than_or_equal(attr, value)
      @conditions << Conditions::GreaterThanOrEqual.new(attr, value)
    end

    # Adds an Include condition.
    #
    # @param (see Conditions::Include#initialize)
    def include(attr, values, &block)
      @conditions << Conditions::Include.new(attr, values, &block)
    end

    # Adds an Included condition.
    #
    # @param (see Conditions::Included#initialize)
    def included(attr, value, &block)
      @conditions << Conditions::Included.new(attr, value, &block)
    end

    # Adds a LessOrEqualThan condition.
    #
    # @param (see Conditions::LessOrEqualThan#initialize)
    def less_than_or_equal(attr, value, &block)
      @conditions << Conditions::LessThanOrEqual.new(attr, value)
    end

    # Adds a LessThan condition.
    #
    # @param (see Conditions::LessThan#initialize)
    def less_than(attr, value)
      @conditions << Conditions::LessThan.new(attr, value)
    end

    # Adds a TZ condition block
    #
    # @param [String] tz_identifier String representing IANA's time zone identifier. Defaults to UTC if none passed.
    # @yield Evaluates the given block in the context of the TZ rule
    def tz(tz_identifier = 'UTC', &block)
      cond = Conditions::TZ.new(tz_identifier)
      cond.instance_exec(&block)

      @conditions << cond
    end

    # Gets attribute's value from the given name.
    #
    # @param name
    #
    # @return The attribute's value.
    def get(name)
      @attrs[name]
    end

    # Sets a custom attribute.
    #
    # @param name Attribute's name
    # @param value Attribute's value
    def set(name, value)
      @attrs[name] = value
    end

    # Defines a variable.
    #
    # If both value and block are given, only the block will be taken into account.
    #
    # @param name The name of the variable
    # @param value The value of the variable
    #
    # @yield a block that will resolve the variable's value
    def var(name, value = nil, &block)
      if block_given?
        @vars[name] = block
      else
        @vars[name] = lambda { value }
      end
    end

    # Evaluates all conditions.
    #
    # @return [true] When all conditions succeeds
    # @return [false] Otherwise
    def call(ctx)
      success = @conditions.take_while do |condition|
        condition.call(ctx)
      end

      success.length == @conditions.length
    rescue NoMethodError
      false
    end

    def ==(o)
      o.kind_of?(Rule) &&
        conditions == o.conditions &&
        vars.keys == o.vars.keys
    end

    private

    # Getter method for rules params. It returns all the params without nil objects
    #
    # @return [Array<Object>]
    def params
      @params.compact
    end

  end
end
