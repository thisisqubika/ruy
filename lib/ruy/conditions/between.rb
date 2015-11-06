module Ruy
  module Conditions

    # Expects that a context value belongs to a given range.
    #
    # Comparison formula: from <= context[attr] <= to
    class Between < Condition
      attr_reader :from, :to, :attr

      # @param from Range lower bound
      # @param to Range upper bound
      # @param attr Name of the attribute that will be evaluated
      def initialize(from, to, *attrs)
        super
        @from = from
        @to = to
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(Between) &&
          o.from == @from &&
          o.to == @to &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        @from <= value && @to >= value
      end
    end
  end
end
