module Ruy
  module Conditions
    class InCyclicOrder < Condition
      attr_reader :from, :to, :attr

      def initialize(from, to, attr, &block)
        super
        @from = from
        @to = to
        @attr = attr
        instance_exec(&block) if block_given?
      end

      def call(ctx)
        value = ctx.resolve(@attr)

        if @from > @to
          (@from <= value || @to >= value) && super
        else
          (@from <= value && @to >= value) && super
        end
      end

      def ==(o)
        o.kind_of?(self.class) &&
          @from == o.from &&
          @to   == o.to &&
          @attr == o.attr &&
          self.conditions == o.conditions
      end
    end
  end
end
