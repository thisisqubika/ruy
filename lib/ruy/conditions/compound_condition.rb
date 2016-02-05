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
      # @return [true] When all the conditions are satisfied
      # @return [false] Otherwise
      def call(ctx)
        @conditions.all? do |condition|
          condition.call(ctx)
        end
      end

      def ==(o)
        o.kind_of?(self.class) &&
          o.conditions == @conditions
      end

    end
  end
end
