module Ruy
  module Conditions

    # Expects that all rules will succeed.
    class All < Ruy::Rule
      def call(var_ctx)
        @conditions.all? do |condition|
          condition.call(var_ctx)
        end
      end
    end
  end
end
