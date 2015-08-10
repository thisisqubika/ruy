module Ruy
  module Conditions

    # Expects that a context value belongs to a given range.
    #
    # Comparison formula: from <= context[attr] <= to
    class Between < Ruy::Rule
      attr_reader :attr, :from, :to

      # @param from Range lower bound
      # @param to Range upper bound
      # @param attr Name of the attribute that will be evaluated
      #
      # @yield a block in the context of the current rule
      def initialize(from, to, attr, &block)
        super
        @from = from
        @to = to
        @attr = attr
        instance_exec(&block) if block_given?
      end

      def call(ctx)
        value = ctx.resolve(@attr)
        @from <= value && @to >= value && super
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
