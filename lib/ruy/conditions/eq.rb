module Ruy
  module Conditions

    # Expects that a context attribute will be equal to a given value.
    class Eq < Condition
      attr_reader :obj, :attr

      # @param obj Expected object
      # @param attr Context attribute's name
      def initialize(obj, *attrs)
        super
        @obj = obj
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(Eq) &&
          o.obj == @obj &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        @obj == value
      end

    end
  end
end
