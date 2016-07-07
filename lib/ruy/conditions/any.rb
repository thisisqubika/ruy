module Ruy
  module Conditions

    # Expects that at least one of the sub-conditions is satisfied
    #
    class Any < CompoundCondition

      protected

      # @see CompoundCondition#evaluate
      def evaluate(ctx)
        conditions.any? do |condition|
          condition.call(ctx)
        end
      end

    end
  end
end
