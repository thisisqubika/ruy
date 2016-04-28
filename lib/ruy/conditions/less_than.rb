module Ruy
  module Conditions

    # Expects that a context attribute will be less than the given value
    #
    class LessThan < Condition
      attr_reader :obj, :key

      # @param obj
      # @param key
      # @example check that :key is less than 5
      #   LessThan.new(5, :key)
      def initialize(obj, *keys)
        @obj = obj
        @key = keys.first if keys.any?
      end

      def ==(o)
        o.kind_of?(LessThan) &&
          o.obj == @obj &&
          o.key == @key
      end

      protected

      def evaluate(value)
        @obj > value
      end
    end
  end
end
