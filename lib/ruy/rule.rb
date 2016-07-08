module Ruy
  class Rule
    include DSL
    include Utils::Printable

    attr_reader :conditions
    attr_reader :outcomes

    def initialize
      @attrs = {}
      @conditions = []
      @fallback = nil
      @lets = []
      @outcomes = []
    end

    # Gets attribute's value from the given name
    #
    # @param name
    #
    # @return the attribute's value
    def get(name)
      @attrs[name]
    end

    # Sets a custom attribute
    #
    # @param name
    # @param value
    def set(name, value)
      @attrs[name] = value
    end

    # Evaluates that rule conditions return the corresponding outcome
    # or fallback depending on whether the conditions matched or not
    #
    # @param context [Hash]
    #
    # @return outcome or fallback values
    def call(context)
      ctx = Context.new(context, @lets)

      if Ruy::Utils::Rules.evaluate_conditions(@conditions, ctx)
        Ruy::Utils::Rules.compute_outcome(@outcomes, ctx)
      else
        @fallback
      end
    end

    # Stores the name of a lazy variable whose block will be defined
    # in the evaluated context
    #
    # @param name [Symbol]
    def let(name)
      @lets << name
    end

    # Defines the fallback value to be returned when conditions are not met
    #
    # @param value
    def fallback(value)
      @fallback = value
    end

    # Defines the outcome value to be returned when conditions are met
    #
    # @param value
    # @yield value
    def outcome(value, &block)
      outcome = Outcome.new(value)
      outcome.instance_exec(&block) if block_given?
      @outcomes << outcome
    end

    # Outputs a DSL-compliant description of the rule
    #
    # @return [String]
    def to_s
      s = @attrs.map { |name, value| "set #{name.inspect}, #{value.inspect}" }.join("\n")
      s << "\n\n" if @attrs.any?

      s << @lets.map { |name| "let #{name.inspect}" }.join("\n")
      s << "\n\n" if @lets.any?

      s << self.conditions.join("\n")

      if @outcomes.any?
        s << "\n" unless s == ''
        s << @outcomes.join("\n")
      end

      if @fallback
        s << "\n" unless s == ''
        s << "fallback #{@fallback.inspect}\n"
      end

      s
    end

  end
end
