module Ruy
  module Conditions

    # Expects that a context value belongs to a given range.
    #
    # Comparison formula: from <= context[attr] <= to
    class Between < Ruy::Rule
      attr_reader :attr, :from, :to

      # @param attr Name of the attribute that will be evaluated
      # @param from Range lower bound
      # @param to Range upper bound
      # @yield a block in the context of the current rule
      def initialize(attr, from, to, &block)
        super()

        @attr = attr
        @from = from
        @to = to

        @params = [@attr, @from, @to]

        instance_exec(&block) if block_given?
      end

      def call(var_ctx)
        value = var_ctx.resolve(@attr)
        @from <= value && value <= @to && super
      end

      def ==(o)
        o.kind_of?(Between) &&
          @attr == o.attr &&
          @from == o.from &&
          @to   == o.to &&
          self.conditions == o.conditions
      end
    end
  end
end
