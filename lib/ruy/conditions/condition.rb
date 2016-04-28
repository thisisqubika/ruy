module Ruy
  module Conditions

    # Abstract base class for simple conditions
    #
    # @abstract
    class Condition
      include Ruy::DSL

      attr_reader :params

      def initialize(*params)
        @params = params
      end

      # Evaluates a context's object for its compliance with the condition.
      #
      # @param [Context] ctx
      # @return [Boolean]
      def call(ctx)
        evaluate(resolve(ctx))
      end

      protected

      attr_reader :key

      # Returns true if a key has been defined among the condition attributes
      #
      # @return [Boolean]
      def has_key?
        defined? @key
      end

      # Evaluates an object to check if it satisfies the condition
      #
      # @abstract
      # @param obj
      # @return [Boolean] true if it satisfies the condition, false otherwise
      def evaluate(obj); end

      # Lookups the object of evaluation in the context
      # based on the initialization attribute
      #
      # @param [Context] ctx
      # @return an object stored in the context
      def resolve(ctx)
        has_key? ? ctx.resolve(key) : ctx.object
      end

    end
  end
end
