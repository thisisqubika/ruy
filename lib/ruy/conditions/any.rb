module Ruy
  module Conditions

    # Expects that at least one of the rules will succeed.
    class Any < Condition
      def call(ctx)
        conditions.any? do |condition|
          condition.call(ctx)
        end
      end

      def ==(o)
        o.kind_of?(Any) &&
          conditions == o.conditions
      end
    end
  end
end
