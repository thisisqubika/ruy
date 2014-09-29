module Ruy
  module Conditions

    # Expects that a context attribute will be equal to a given value.
    #
    class Eq < Ruy::Rule
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value Expected value
      def initialize(attr, value)
        super
        @attr = attr
        @value = value
      end

      def call(var_ctx)
        var_ctx.resolve(@attr) == @value
      end

      def ==(o)
        o.kind_of?(Eq) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
