module Ruy
  module Conditions

    # Expects that a context attribute will be less than or equal to the given value.
    class LessThanOrEqual < Condition
      attr_reader :obj, :attr

      # @param obj Context attribute's name
      # @param attr
      def initialize(obj, *attrs)
        super
        @obj = obj
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(LessThanOrEqual) &&
          o.obj == @obj &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        @obj >= value
      end

    end
  end
end
