module Ruy
  module Conditions

    # Expects that a context attribute will be greater than or equal to the given value.
    class GreaterThanOrEqual < Ruy::Rule
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value
      # @yield a block in the context of the current rule
      def initialize(attr, value, &block)
        super
        @attr = attr
        @value = value
        instance_exec(&block) if block_given?
      end

      def call(var_ctx)
        @value <= var_ctx.resolve(@attr) && super
      end

      def ==(o)
        o.kind_of?(GreaterThanOrEqual) &&
          attr == o.attr &&
          value == o.value &&
          self.conditions == o.conditions
      end
    end
  end
end
