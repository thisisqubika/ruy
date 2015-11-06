module Ruy
  module Conditions
    class InCyclicOrder < Condition
      attr_reader :from, :to, :attr

      def initialize(from, to, *attrs)
        super
        @from = from
        @to = to
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(self.class) &&
          o.from == @from &&
          o.to   == @to &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        if @from > @to
          (@from <= value || @to >= value)
        else
          (@from <= value && @to >= value)
        end
      end

    end
  end
end
