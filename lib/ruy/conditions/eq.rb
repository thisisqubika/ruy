module Ruy
  module Conditions

    # Expects that a context attribute will be equal to a given value
    #
    class Eq < Condition
      attr_reader :obj, :key

      # @param obj
      # @param key
      # @example evaluate that :key is 5
      #   Eq.new(5, :key)
      def initialize(obj, *keys)
        super
        @obj = obj
        @key = keys.first if keys.any?
      end

      def ==(o)
        o.kind_of?(Eq) &&
          o.obj == @obj &&
          o.key == @key
      end

      protected

      def evaluate(value)
        @obj == value
      end

    end
  end
end
