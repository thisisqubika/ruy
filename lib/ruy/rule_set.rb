module Ruy
  class RuleSet
    include DSL

    attr_reader :lets
    attr_reader :outcomes

    def initialize
      super

      @lets = []
      @outcomes = []

      @fallback = nil

      @rule = Ruy::Rule.new
    end

    def conditions
      @rule.conditions
    end

    def outcome(value, &block)
      outcome = Outcome.new(value)
      outcome.instance_exec(&block) if block_given?
      @outcomes << outcome
    end

    def fallback(value)
      @fallback = value
    end

    # @param [Hash] context
    def call(context)
      ctx = Context.new(context, @lets)
      if @apply = @rule.call(ctx)
        compute_outcome(ctx)
      else
        @fallback
      end
    end

    def apply?
      @apply
    end

    def compute_outcome(ctx)
      @outcomes.each do |outcome|
        result = outcome.call(ctx)
        unless result.nil?
          return result
        end
      end

      nil
    end

    # Defines a memoized value.
    #
    # The value will be resolved upon the context during evaluation. Let is lazy evaluated, it is
    # not evaluated until the first condition referencing it is invoked. Once evaluated, it's value
    # is stored, so subsequent invocations during the same evaluation will resolve again its value.
    def let(name)
      @lets << name
    end

    def to_s
      s = lets.map { |name| "let #{name.inspect}" }.join("\n")

      s << "\n\n" unless s == ''

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
