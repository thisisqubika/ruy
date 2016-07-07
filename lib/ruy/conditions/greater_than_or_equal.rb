module Ruy
  module Conditions

    # Expects that a context attribute will be greater than or
    # equal to the given value
    #
    class GreaterThanOrEqual < Condition
      attr_reader :obj

      # @param obj
      # @param key
      # @example check that :key is greater than or equal to 5
      #   GreaterThanOrEqual.new(5, :key)
      def initialize(obj, *key)
        super
        @obj = obj
        @key = key.first if key.any?
      end

      def ==(o)
        o.kind_of?(GreaterThanOrEqual) &&
          o.obj == @obj &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
      def evaluate(value)
        @obj <= value
      end

    end
  end
end
