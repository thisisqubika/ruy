module Ruy
  module Conditions

    # Asserts that an attribute has a truth value.
    class Assert < Ruy::Rule
      attr_reader :attr

      # @param attr Context attribute's name
      def initialize(attr)
        super
        @attr = attr
      end

      def call(ctx)
        ctx.resolve(@attr)
      end

      def ==(o)
        o.kind_of?(Assert) &&
          @attr == o.attr
      end
    end
  end
end
