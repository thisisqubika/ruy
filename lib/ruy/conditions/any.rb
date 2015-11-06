module Ruy
  module Conditions

    # Expects that at least one of the sub-conditions is be satisfied.
    class Any < CompoundCondition
      def call(ctx)
        conditions.any? do |condition|
          condition.call(ctx)
        end
      end

    end
  end
end
