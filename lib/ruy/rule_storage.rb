module Ruy
  class RuleStorage
    attr_writer :adapter

    def initialize(adapter, rules = [])
      @adapter = adapter
      @rules = rules
    end

    # Evaluate the given context against all the loaded rules
    #
    # @param [Hash] ctx
    # @return [Array<Object>]
    def evaluate_all(ctx)
      @rules.map { |rule| rule.call(ctx) }.compact
    end

    # The first rule that apply will return the method
    #
    # @param [Hash] ctx
    # @return [Object]
    def evaluate_first(ctx)
      @rules.each do |rule|
        result = rule.call(ctx)
        return result if rule.apply?
      end
    end

    # Load all the rules from the adapter
    #
    def load_rules(params = {}, &block)
      @rules = @adapter.load_rules(params, &block)
    end
    alias_method :relaod, :load_rules
  end
end
