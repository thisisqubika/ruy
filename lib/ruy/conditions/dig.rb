module Ruy
  module Conditions

    # Digs into a Hash allowing to define conditions over nested attributes
    class Dig < CompoundCondition
      attr_reader :chain

      # @param *chain Context attributes' chain
      def initialize(*chain)
        super
        @chain = chain
      end

      def call(ctx)
        leafctx = @chain.reduce(ctx) do |currentctx, attr|
          if currentctx.include?(attr)
            Ruy::Context.new(currentctx.resolve(attr))
          else
            return false
          end
        end

        Ruy::Utils::Rules.evaluate_conditions(conditions, leafctx)
      end

      def ==(o)
        super &&
          o.chain == @chain
      end
    end
  end
end
