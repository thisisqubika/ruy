module Ruy
  module Conditions

    # Expects that a context attribute will be less than or equal to the given value.
    class LessThanOrEqual < Ruy::Rule
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value
      def initialize(attr, value)
        @attr = attr
        @value = value

        @params = [@attr, @value]
      end

      def call(var_ctx)
        var_ctx.resolve(@attr) <= @value
      end

      def ==(o)
        o.kind_of?(LessThanOrEqual) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
