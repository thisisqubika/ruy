module Ruy
  module Conditions

    # Expects that a context value belongs to a given range.
    #
    # Comparison formula: from <= context[attr] <= to
    class Between < Condition
      attr_reader :from, :to, :range, :attr

      # @overload initialize(from, to, attr)
      #   @param from Range lower bound
      #   @param to Range upper bound
      #   @param attr Name of the attribute that will be evaluated
      # @overload initialize(range, attr)
      #   @param range Range
      #   @param attr Name of the attribute that will be evaluated
      def initialize(*args)
        super

        if Range === args[0]
          @range = args[0]
          @attr = args[1] if args.length > 1
        else
          @from, @to = args[0], args[1]
          @attr = args[2] if args.length > 2
        end
      end

      def ==(o)
        o.kind_of?(Between) &&
          o.from == @from &&
          o.to == @to &&
          o.range == @range &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        if @range
          @range.include?(value)
        else
          @from <= value && @to >= value
        end
      end
    end
  end
end
