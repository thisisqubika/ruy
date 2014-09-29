module Ruy
  module Conditions

    # Expects that a condition is not met.
    #
    # When a sub-rule is given, Except will expect an unsuccessful evaluation of that sub-rule.
    # When a sub-rule is not given, Except will expect a context attribute is not equal to a given
    # value.
    class Except < Ruy::Rule
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value Non-expected value
      # @yield a block in the context of the current rule
      def initialize(attr = nil, value = nil, &block)
        super
        @attr = attr
        @value = value
        instance_exec(&block) if block_given?
      end

      def call(var_ctx)
        result = true

        if @attr
          result &&= var_ctx.resolve(@attr) != @value
        end

        if self.conditions.any?
          result &&= !super(var_ctx)
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
