module Ruy
  module Conditions

    # Navigates into a Hash allowing to define conditions over nested attributes
    #
    class Dig < CompoundCondition
      attr_reader :chain

      # @param chain [Array<Object>] Sequence of keys to navigate the hash hierarchy
      # @example navigate key -> sub_key -> sub_sub_key
      #   Dig.new(:key, :sub_key, :sub_sub_key)
      def initialize(*chain)
        super
        @chain = chain
      end

      def ==(o)
        super &&
          o.chain == @chain
      end

      protected

      # @see CompoundCondition#evaluate
      def evaluate(ctx)
        ctx && Ruy::Utils::Rules.evaluate_conditions(conditions, ctx)
      end

      # @see CompoundCondition#resolve
      def resolve(ctx)
        @chain.reduce(ctx) do |currentctx, key|
          if currentctx.include?(key)
            Ruy::Context.new(currentctx.resolve(key))
          else
            return false
          end
        end
      end

    end
  end
end
