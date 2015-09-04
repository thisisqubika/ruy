module Ruy
  module Conditions

    # Expects that a context attribute is included in a set of values.
    class In < Condition
      attr_reader :attr, :values

      # @param values Expected set of values
      # @param attr Context attribute's name
      # @yield a block in the context of the current rule
      def initialize(values, attr, &block)
        super
        @values = values
        @attr = attr
      end

      def call(var_ctx)
        self.values.include?(var_ctx.resolve(self.attr))
      end

      def ==(o)
        o.kind_of?(In) &&
          self.attr == o.attr &&
          self.values == o.values
      end
    end

  end
end
