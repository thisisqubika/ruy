module Ruy
  module Conditions

    # Expects that a context value belongs to a given range.
    #
    # Comparison formula: from <= context[attr] <= to
    class Between < Condition
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
      end

      def call(ctx)
        value = ctx.resolve(@attr)
        @from <= value && @to >= value
      end

      def ==(o)
        o.kind_of?(Between) &&
          @attr == o.attr &&
          @from == o.from &&
          @to   == o.to
      end
    end
  end
end
