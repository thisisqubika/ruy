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

    # Evaluates rule conditions return the corresponding outcome or fallback depending on whether
    # the conditions matched or not.
    #
    # @param [Hash] context
    #
    # @return [Object] outcome or fallback
    def call(context)
      ctx = Context.new(context, @lets)

      if Ruy::Utils::Rules.evaluate_conditions(@conditions, ctx)
        Ruy::Utils::Rules.compute_outcome(@outcomes, ctx)

      else
        @fallback
      end
    end

    # TODO document
    def fallback(value)
      @fallback = value
    end

    # Defines a memoized value.
    #
    # The value will be resolved upon the context during evaluation. Let is lazy evaluated, it is
    # not evaluated until the first condition referencing it is invoked. Once evaluated, its value
    # is stored, so subsequent invocations during the same evaluation will resolve again its value.
    def let(name)
      @lets << name
    end

    # TODO document
    def outcome(value, &block)
      outcome = Outcome.new(value)
      outcome.instance_exec(&block) if block_given?
      @outcomes << outcome
    end

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
