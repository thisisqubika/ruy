module Ruy
  module Conditions

    # Expects that a condition is not met.
    #
    # When a sub-rule is given, Except will expect an unsuccessful evaluation of that sub-rule.
    # When a sub-rule is not given, Except will expect a context attribute is not equal to a given
    # value.
    class Except < CompoundCondition
      attr_reader :attr, :value

      # @param value Non-expected value
      # @param attr Context attribute's name
      # @yield a block in the context of the current rule
      def initialize(value = nil, attr = nil, &block)
        super
        @value = value
        @attr = attr
        instance_exec(&block) if block_given?
      end

      def call(ctx)
        result = true

        if @attr
          result &&= ctx.resolve(@attr) != @value
        end

        if self.conditions.any?
          result &&= !super(ctx)
        end

        result
      end

      def ==(o)
        o.kind_of?(Except) &&
          @attr == o.attr &&
          @value == o.value &&
          @conditions == o.conditions
      end
    end
  end
end
