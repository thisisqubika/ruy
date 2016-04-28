module Ruy
  module Conditions

    # Expects that the sub-condition is not satisfied
    class Except < CompoundCondition

      # @example check that :key does not contain a truthy value
      #   Except.new { assert :key }
      # @yield a block in the context of the current rule
      def initialize(&block)
        super
        instance_exec(&block) if block_given?
      end

      def evaluate(ctx)
        !super
      end

    end
  end
end
