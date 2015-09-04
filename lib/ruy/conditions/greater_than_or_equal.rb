module Ruy
  module Conditions

    # Expects that a context attribute will be greater than or equal to the given value.
    class GreaterThanOrEqual < Condition
      attr_reader :attr, :value

      # @param value
      # @param attr Context attribute's name
      # @yield a block in the context of the current rule
      def initialize(value, attr, &block)
        super
        @value = value
        @attr = attr
      end

      def call(ctx)
        @value <= ctx.resolve(@attr)
      end

      def ==(o)
        o.kind_of?(GreaterThanOrEqual) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
