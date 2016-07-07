module Ruy
  module Conditions

    # Iterates over an Enumerable evaluating that some value
    # matches the set of sub-conditions
    #
    class Some < CompoundCondition

      # @param key
      # @example check that at least a value from :key matches the sub-conditions
      #   Some.new(:key)
      def initialize(*key)
        super
        @key = key.first if key.any?
      end

      # @see CompoundCondition#evaluate
      def evaluate(enum)
        enum.any? do |ctx|
          new_ctx = Ruy::Context.new(ctx)

          Ruy::Utils::Rules.evaluate_conditions(conditions, new_ctx)
        end
      end

      def ==(o)
        super &&
          o.key == @key
      end
    end
  end
end
