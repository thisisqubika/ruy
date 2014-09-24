module Ruy
  class RuleSet < Rule
    attr_reader :outcomes

    def initialize
      super
      @outcomes = []
      @fallback = nil
    end

    def outcome(value, &block)
      outcome = Outcome.new(value)
      outcome.instance_exec(&block) if block_given?
      @outcomes << outcome
    end

    def fallback(value)
      @fallback = value
    end

    def call(ctx)
      var_ctx = VariableContext.new(ctx, @vars)
      if @apply = super(var_ctx)
        compute_outcome(var_ctx)
      else
        @fallback
      end
    end

    def apply?
      @apply
    end

    def compute_outcome(var_ctx)
      @outcomes.each do |outcome|
        result = outcome.call(var_ctx)
        unless result.nil?
          return result
        end
      end

      nil
    end

    def to_s
      s = ''

      s << @conditions.join("\n")

      if @outcomes.any?
        s << "\n" unless s == ''
        s << @outcomes.join("\n")
      end

      if @fallback
        s << "\n\n" unless s == ''
        s << "fallback #{@fallback.inspect}\n"
      end

      s
    end

  end

end
