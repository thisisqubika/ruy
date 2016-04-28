module Ruy
  module Conditions

    # Expects that a context attribute will be greater than the given value
    #
    class GreaterThan < Condition
      attr_reader :obj, :key

      # @param obj
      # @param key
      # @example expects that :key is greater than 5
      #   GreaterThan.new(5, :key)
      def initialize(obj, *keys)
        super
        @obj = obj
        @key = keys.first if keys.any?
      end

      def ==(o)
        o.kind_of?(GreaterThan) &&
          o.obj == @obj &&
          o.key == @key
      end

      protected

      def evaluate(value)
        @obj < value
      end

    end
  end
end
