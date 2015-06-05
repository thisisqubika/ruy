module Ruy
  module Conditions

    # Expects that a context attribute will be equal to a given value.
    #
    class Eq < Ruy::Rule
      attr_reader :attr, :value

      # @param value Expected value
      # @param attr Context attribute's name
      def initialize(value, attr)
        super
        @value = value
        @attr = attr
      end

      def call(ctx)
        @value == ctx.resolve(@attr)
      end

      def ==(o)
        o.kind_of?(Eq) &&
          attr == o.attr &&
          value == o.value
      end
    end
  end
end
