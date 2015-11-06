module Ruy
  module Conditions

    # Asserts that an attribute has a truthy value.
    class Assert < Condition
      attr_reader :attr

      # @param attr Context attribute's attr
      def initialize(*attrs)
        super
        @attr = attrs.first if attrs.any?
      end

      def ==(o)
        o.kind_of?(Assert) &&
          o.attr == @attr
      end
    end
  end
end
