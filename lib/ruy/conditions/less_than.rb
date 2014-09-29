module Ruy
  module Conditions

    # Expects that a context attribute will be less than given value.
    class LessThan < Ruy::Rule
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value
      def initialize(attr, value)
        super
        @attr = attr
        @value = value
      end

      def call(var_ctx)
        var_ctx.resolve(@attr) < @value
      end

      def ==(o)
        o.kind_of?(LessThan) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
