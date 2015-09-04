module Ruy
  module Conditions

    # Expects that a value is included in a set of values from the context attribute.
    class Include < Condition
      attr_reader :attr, :value

      # @param value Expected set of values
      # @param attr Context attribute's name
      # @yield a block in the context of the current rule
      def initialize(value, attr, &block)
        super
        @value = value
        @attr = attr
      end

      def call(ctx)
        ctx.resolve(self.attr).include?(self.value)
      end

      def ==(o)
        o.kind_of?(Include) &&
          self.attr == o.attr &&
          self.value == o.value
      end
    end
  end
end
