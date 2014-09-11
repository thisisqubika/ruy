module Ruy
  class RuleSet < Rule
    attr_reader :name
    attr_reader :outcomes
    attr_accessor :metadata

    def initialize
      super

      @outcomes = []
      @fallback = nil
      @metadata = {}
    end

    def [](key)
      @metadata[key]
    end

    def []=(key, value)
      @metadata[key] = value
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

    def to_hash
      if @outcomes.any?
        super.merge({ outcomes: @outcomes.map { |o| o.to_hash } })
      end
    end

    def fallback(value)
      @fallback = value
    end

    def outcome(value, &block)
      outcome = Outcome.new(value)

      outcome.instance_exec(&block) if block_given?

      @outcomes << outcome
    end

    def method_missing(m, *args, &block)
      super
    end
  end
end
