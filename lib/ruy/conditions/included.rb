module Ruy
  module Conditions

    # Expects that a value is included in a set of values from the context attribute.
    class Included < Condition
      attr_reader :attr, :value

      # @param attr Context attribute's name
      # @param value Expected set of values
      # @yield a block in the context of the current rule
      def initialize(attr, value, &block)
        super
        @attr = attr
        @value = value
      end

      def call(ctx)
        ctx.resolve(self.attr).include?(self.value)
      end

      def ==(o)
        o.kind_of?(Included) &&
          self.attr == o.attr &&
          self.value == o.value
      end
    end
  end
end
