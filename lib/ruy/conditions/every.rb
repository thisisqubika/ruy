module Ruy
  module Conditions

    # Iterates over an Enumerable evaluating that every value matches the set of sub-conditions.
    class Every < CompoundCondition
      attr_reader :attr

      # @param attr Context attribute's name
      def initialize(attr)
        super
        @attr = attr
      end

      def call(ctx)
        enumerable = ctx.resolve(@attr)

        enumerable.all? do |context|
          ctx = Ruy::Context.new(context)

          Ruy::Utils::Rules.evaluate_conditions(conditions, ctx)
        end
      end

      def ==(o)
        o.kind_of?(Every) &&
          attr == o.attr &&
          conditions == o.conditions
      end
    end
  end
end
