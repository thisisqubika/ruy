module Ruy
  module Conditions

    # Expects that a condition is not met.
    #
    # When a sub-rule is given, Except will expect an unsuccessful evaluation of that sub-rule.
    # When a sub-rule is not given, Except will expect a context attribute is not equal to a given
    # value.
    class Except < CompoundCondition

      # @param value Non-expected value
      # @param attr Context attribute's name
      # @yield a block in the context of the current rule
      def initialize(&block)
        super
        instance_exec(&block) if block_given?
      end

      def call(ctx)
        !super
      end

      def ==(o)
        o.kind_of?(Except) &&
          @conditions == o.conditions
      end
    end
  end
end
