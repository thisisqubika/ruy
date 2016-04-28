module Ruy
  module Conditions

    # Iterates over an Enumerable evaluating that some value
    # matches the set of sub-conditions
    #
    class Some < CompoundCondition
      attr_reader :key

      # @param key
      # @example check that at least a value from :key matches the sub-conditions
      #   Some.new(:key)
      def initialize(*keys)
        super
        @key = keys.first if keys.any?
      end

      def evaluate(enum)
        enum.any? do |ctx|
          newctx = Ruy::Context.new(ctx)

          Ruy::Utils::Rules.evaluate_conditions(conditions, newctx)
        end
      end

      def ==(o)
        super &&
          o.key == @key
      end
    end
  end
end
