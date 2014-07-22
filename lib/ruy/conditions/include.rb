module Ruy
  module Conditions

    # Expects that a context attribute is included in a set of values.
    class Include < Ruy::Rule
      attr_reader :attr, :values

      # @param attr Context attribute's name
      # @param values Expected set of values
      # @yield a block in the context of the current rule
      def initialize(attr, values, &block)
        super()

        @attr = attr
        @values = values

        @params = [@attr, @values]

        instance_exec(&block) if block_given?
      end

      def call(var_ctx)
        self.values.include?(var_ctx.resolve(self.attr)) && super
      end

      def ==(o)
        o.kind_of?(Include) &&
          self.attr == o.attr &&
          self.values == o.values &&
          self.conditions == o.conditions
      end
    end
  end
end
