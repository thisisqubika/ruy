module Ruy
  module Conditions

    class CompoundCondition < Condition

      attr_reader :conditions

      def initialize(*params)
        super

        @conditions = []
      end

      # Evaluates all conditions.
      #
      # @return [true] When all conditions succeeds
      # @return [false] Otherwise
      def call(ctx)
        @conditions.all? do |condition|
          condition.call(ctx)
        end
      end
    end
  end
end
