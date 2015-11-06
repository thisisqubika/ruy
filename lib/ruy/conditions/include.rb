module Ruy
  module Conditions

    # Expects that a value is included in a set of values from the context attribute.
    class Include < Condition
      attr_reader :obj, :attr

      # @param value Expected set of values
      # @param attr Context attribute's name
      def initialize(obj, *attrs)
        super
        @obj = obj
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(Include) &&
          o.obj == @obj &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        value.include?(@obj)
      end

    end
  end
end
