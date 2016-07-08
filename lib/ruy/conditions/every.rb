module Ruy
  module Conditions

    # Iterates over an Enumerable evaluating that every value
    # matches the set of sub-conditions
    #
    class Every < CompoundCondition

      # @param key
      # @example check that every element of :array matches the sub-conditions
      #   Every.new(:array)
      def initialize(*key)
        super
        @key = key.first if key.any?
      end

      def ==(o)
        super &&
          o.key == @key
      end

      protected

      # @see CompoundCondition#evaluate
      def evaluate(enum)
        enum.all? do |ctx|
          newctx = Ruy::Context.new(ctx)

          Ruy::Utils::Rules.evaluate_conditions(conditions, newctx)
        end
      end

    end
  end
end
