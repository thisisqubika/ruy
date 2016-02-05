module Ruy
  module Conditions

    # Expects that a context attribute will be less than the given value.
    class LessThan < Condition
      attr_reader :obj, :attr

      # @param obj
      # @param attr Context attribute's name
      def initialize(obj, *attrs)
        @obj = obj
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(LessThan) &&
          o.obj == @obj &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        @obj > value
      end
    end
  end
end
