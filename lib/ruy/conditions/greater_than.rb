module Ruy
  module Conditions

    # Expects that a context attribute will be greater than the given value
    #
    class GreaterThan < Condition
      attr_reader :obj

      # @param obj
      # @param key
      # @example expects that :key is greater than 5
      #   GreaterThan.new(5, :key)
      def initialize(obj, *key)
        super
        @obj = obj
        @key = key.first if key.any?
      end

      def ==(o)
        o.kind_of?(GreaterThan) &&
          o.obj == @obj &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
      def evaluate(value)
        @obj < value
      end

    end
  end
end
