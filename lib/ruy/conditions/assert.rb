module Ruy
  module Conditions

    # Expects that the context key stores a truthy value
    #
    class Assert < Condition
      # @param key
      # @example evaluate that :key passes
      #   Assert.new(:key)
      def initialize(*key)
        super
        @key = key.first if key.any?
      end

      def ==(o)
        o.kind_of?(Assert) &&
          o.key == @key
      end

      protected

      # @see Condition#evaluate
      def evaluate(obj)
        !!obj
      end

    end
  end
end
