module Ruy
  module Conditions

    # Expects that a context attribute will be greater than or equal to the given value.
    class GreaterThanOrEqual < Condition
      attr_reader :obj, :attr

      # @param obj
      # @param attr Context attribute's name
      def initialize(obj, *attrs)
        super
        @obj = obj
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(GreaterThanOrEqual) &&
          o.obj == @obj &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        @obj <= value
      end

    end
  end
end
