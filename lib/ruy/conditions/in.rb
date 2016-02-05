module Ruy
  module Conditions

    # Expects that a context attribute is included in a set of values.
    class In < Condition
      attr_reader :ary, :attr

      # @param ary Expected set of values
      # @param attr Context attribute's name
      def initialize(ary, *attrs)
        super
        @ary = ary
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(In) &&
          o.ary == @ary &&
          o.attr == @attr
      end

      protected

      def evaluate(value)
        @ary.include?(value)
      end
    end

  end
end
