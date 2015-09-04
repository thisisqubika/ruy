module Ruy
  module Conditions

    # Expects that a context attribute will be less than or equal to the given value.
    class LessThanOrEqual < Condition
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value
      def initialize(value, attr)
        super
        @value = value
        @attr = attr
      end

      def call(ctx)
        @value >= ctx.resolve(@attr)
      end

      def ==(o)
        o.kind_of?(LessThanOrEqual) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
