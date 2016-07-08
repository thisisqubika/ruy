module Ruy
  module Conditions

    # Expects that a context key stores a value included in a defined range
    #
    class Between < Condition
      attr_reader :from, :to, :range

      # @overload initialize(from, to, key)
      #   @param from Range lower bound
      #   @param to Range upper bound
      #   @param key Key that holds the value to be evaluated
      # @overload initialize(range, key)
      #   @param range Range
      #   @param key Key that holds the value to be evaluated
      def initialize(*args)
        super

        if Range === args[0]
          @range = args[0]
          @key = args[1] if args.length > 1
        else
          @from, @to = args[0], args[1]
          @key = args[2] if args.length > 2
        end
      end

      def ==(o)
        o.kind_of?(Between) &&
          o.from == @from &&
          o.to == @to &&
          o.range == @range &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
      # @raise NoMethodError when values that do not support #<=> are passed
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
