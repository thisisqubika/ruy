module Ruy
  module Conditions

    # Expects that a value is contained in a cyclic order
    #
    class InCyclicOrder < Condition
      attr_reader :from, :to

      # @param from left bound
      # @param to right bound
      # @param key
      # @example check that :key is included in a cycle defined between 100 and -100
      #   InCyclicOrder.new(100, -100, :key)
      def initialize(from, to, *key)
        super
        @from = from
        @to = to
        @key = key.first if key.any?
      end

      def ==(o)
        o.kind_of?(self.class) &&
          o.from == @from &&
          o.to   == @to &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
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
