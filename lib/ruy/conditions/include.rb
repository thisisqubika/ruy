module Ruy
  module Conditions

    # Expects that a value is included in a set of values
    # from the context attribute
    #
    class Include < Condition
      attr_reader :obj

      # @param obj
      # @param key
      # @example check that :key includes 5
      #   Include.new(5, :key)
      def initialize(obj, *key)
        super
        @obj = obj
        @key = key.first if key.any?
      end

      def ==(o)
        o.kind_of?(Include) &&
          o.obj == @obj &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
      def evaluate(enum)
        enum.include?(@obj)
      end

    end
  end
end
