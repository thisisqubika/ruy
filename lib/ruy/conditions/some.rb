module Ruy
  module Conditions

    # Iterates over an Enumerable evaluating that some value matches the set of sub-conditions.
    class Some < CompoundCondition
      attr_reader :attr

      # @param attr Context attribute's name
      def initialize(*attrs)
        super
        @attr = attrs.first if attrs.any?
      end

      def call(ctx)
        solve(ctx).any? do |newctx|
          ctx = Ruy::Context.new(newctx)

          Ruy::Utils::Rules.evaluate_conditions(conditions, ctx)
        end
      end

      def ==(o)
        super &&
          o.attr == @attr
      end
    end
  end
end
