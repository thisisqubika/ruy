module Ruy
  # Represents a possible result (outcome) of evaluating a rule set
  #
  # Additionally, an outcome can be composed of rules. In that case, the outcome will evaluate to
  # its value if all of them are evaluated successfully.
  class Outcome
    include DSL

    attr_reader :value

    # @param value The value of this outcome
    def initialize(value)
      @value = value
      @rule = Ruy::Rule.new
    end

    # Returns the value of this outcome is all of the conditions succeed.
    #
    # It also returns the value when there's no conditions.
    #
    # @param [Ruy::Context] ctx
    #
    # @return [Object]
    # @return [nil] If some of the conditions does not succeeds
    def call(ctx)
      if @rule.call(ctx)
        @value
      end
    end

    # @return [Array<Ruy::Rule>]
    def conditions
      @rule.conditions
    end

    # @return [Array] An array containing the value of this outcome
    def params
      [@value]
    end

    def ==(o)
      o.kind_of?(Outcome) &&
        value == o.value &&
        conditions == o.conditions
    end
  end
end
