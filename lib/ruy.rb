require_relative 'ruy/rule'
require_relative 'ruy/adapters'
require_relative 'ruy/conditions'
require_relative 'ruy/rule_storage'
require_relative 'ruy/time_pattern'

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

  class Context < Hash
    def self.from_hash(hash)
       ctx = Context.new
       ctx.merge!(hash)

       ctx
    end
  end

  class Outcome < Rule
    attr_reader :value

    def initialize(value)
      super()

      @value = value
      @params = [@value]
    end

    def call(ctx)
      @value if super(ctx)
    end

    def ==(o)
      o.kind_of?(Outcome) &&
        value == o.value &&
        conditions == o.conditions
    end
  end

  # Context that can resolve variable access
  class VariableContext
    def initialize(ctx, vars = {})
      @ctx = ctx
      @vars = vars
      @resolved_vars = {}
    end

    # Resolve the given attr from the variables or the context
    # If attribute can't be resolved then throw an exception
    #
    # @param [Symbol] attr
    # @return [Object]
    def resolve(attr)
      if @vars.include?(attr)
        @resolved_vars[attr] ||= @ctx.instance_exec(&@vars[attr])
      else
        @ctx.fetch(attr) { |key| @ctx[key.to_s] }
      end
    end
  end

end
