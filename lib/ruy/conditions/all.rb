module Ruy
  module Conditions

    # Expects that all rules will succeed.
    class All < Ruy::Rule
      def call(ctx)
        @conditions.all? do |condition|
          condition.call(ctx)
        end
      end
    end
  end
end
