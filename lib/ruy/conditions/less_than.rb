module Ruy
  module Conditions

    # Expects that a context attribute will be less than given value.
    class LessThan < Condition
      attr_reader :attr, :value

      # @param value
      # @param attr Context attribute's name
      def initialize(value, attr)
        @value = value
        @attr = attr
      end

      def call(ctx)
        @value > ctx.resolve(@attr)
      end

      def ==(o)
        o.kind_of?(LessThan) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
