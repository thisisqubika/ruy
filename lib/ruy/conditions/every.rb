module Ruy
  module Conditions

    # Iterates over an Enumerable evaluating that every value
    # matches the set of sub-conditions
    #
    class Every < CompoundCondition
      attr_reader :key

      # @param key
      # @example check that every element of :array matches the sub-conditions
      #   Every.new(:array)
      def initialize(*keys)
        super
        @key = keys.first if keys.any?
      end

      def ==(o)
        super &&
          o.key == @key
      end

      protected

      def evaluate(enum)
        enum.all? do |ctx|
          newctx = Ruy::Context.new(ctx)

          Ruy::Utils::Rules.evaluate_conditions(conditions, newctx)
        end
      end

    end
  end
end
