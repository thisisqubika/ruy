module Ruy
  module Conditions

    # Expects that a context attribute belongs to a set of values
    #
    class Belong < Condition
      attr_reader :ary

      # @param ary
      # @param key
      # @example check that :key is included in [1,3,5]
      #   Belong.new([1,3,5], :key)
      def initialize(ary, *key)
        super
        @ary = ary
        @key = key.first if key.any?
      end

      def ==(o)
        o.kind_of?(Belong) &&
          o.ary == @ary &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
      def evaluate(value)
        @ary.include?(value)
      end
    end

  end
end
