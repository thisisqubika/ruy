module Ruy
  module Conditions

    # Expects that the sub-condition is not satisfied.
    class Except < CompoundCondition

      # @yield a block in the context of the current rule
      def initialize(&block)
        super
        instance_exec(&block) if block_given?
      end

      def call(ctx)
        !super
      end

    end
  end
end
