module Ruy
  module Conditions
    class InCyclicOrder < Condition
      attr_reader :from, :to, :attr

      def initialize(from, to, attr, &block)
        super
        @from = from
        @to = to
        @attr = attr
      end

      def call(ctx)
        value = ctx.resolve(@attr)

        if @from > @to
          (@from <= value || @to >= value)
        else
          (@from <= value && @to >= value)
        end
      end

      def ==(o)
        o.kind_of?(self.class) &&
          @from == o.from &&
          @to   == o.to &&
          @attr == o.attr
      end
    end
  end
end
