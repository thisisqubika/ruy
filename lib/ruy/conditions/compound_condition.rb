module Ruy
  module Conditions

    # Abstract base class for compound conditions
    #
    # @abstract
    class CompoundCondition < Condition
      attr_reader :conditions

      def initialize(*params)
        super
        @conditions = []
      end

      def ==(o)
        o.kind_of?(self.class) &&
          o.conditions == @conditions
      end

      protected

      # Evaluates a context to check if it satisfies the set of sub-conditions
      #
      # @abstract
      # @param ctx [Context]
      # @return [Boolean] true if satisfies the sub-conditions, false otherwise
      def evaluate(ctx)
        @conditions.all? do |condition|
          condition.call(ctx)
        end
      end

      # Lookups the object of evaluation in the context
      # based on the initialization attribute
      #
      # @param ctx [Context]
      # @return an object if a key has been defined,
      #   the passed context otherwise
      def resolve(ctx)
        has_key? ? ctx.resolve(key) : ctx
      end

    end
  end
end
