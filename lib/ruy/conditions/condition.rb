module Ruy
  module Conditions
    class Condition
      include Ruy::DSL

      attr_reader :params

      def initialize(*params)
        @params = params
      end

      # Evaluates a context value to check whether or not it satisfies the condition.
      #
      # @param [Context] ctx
      # @return [Boolean]
      def call(ctx)
        evaluate(solve(ctx))
      end

      protected

      # Evaluates a value to check if it satisfies the condition.
      #
      # @param [Object] value
      # @return [Boolean]
      def evaluate(value)
        value
      end

      # Lookups the value in the context based on the initialization attribute.
      #
      # @param [Context] ctx
      # @return [Object]
      def solve(ctx)
        defined?(@attr) ? ctx.resolve(@attr) : ctx.values
      end

    end
  end
end
