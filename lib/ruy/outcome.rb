module Ruy
  # Represents a possible result (outcome) of evaluating a rule set
  # Additionally, an outcome can be composed of rules. In that case,
  # the outcome will evaluate to its value
  # if all of them are evaluated successfully.
  #
  class Outcome
    include DSL

    attr_reader :value

    # @param value
    # @example will return true if evaluation passes
    #   Outcome.new(true)
    def initialize(value)
      @value = value
      @root_condition = Ruy::Conditions::All.new
    end

    # Returns the value of this outcome if all of the conditions succeed.
    # It also returns the value when there's no conditions.
    #
    # @param ctx [Ruy::Context]
    #
    # @return the value
    # @return [nil] if conditions are not met
    def call(ctx)
      @value if @root_condition.call(ctx)
    end

    # @return [Array<Ruy::Condition>]
    def conditions
      @root_condition.conditions
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
