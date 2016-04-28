module Ruy
  module Conditions

    # Expects that a value is contained in a cyclic order
    #
    class InCyclicOrder < Condition
      attr_reader :from, :to, :key

      # @param from left bound
      # @param to right bound
      # @param key
      # @example check that :key is between a cycle defined between 100 and -100
      #   InCyclicOrder.new(100, -100, :key)
      def initialize(from, to, *keys)
        super
        @from = from
        @to = to
        @key = keys.first if keys.any?
      end

      def ==(o)
        o.kind_of?(self.class) &&
          o.from == @from &&
          o.to   == @to &&
          o.key == @key
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
