module Ruy
  module Conditions

    # Expects that the context key stores a truthy value
    #
    class Assert < Condition
      attr_reader :key

      # @param key
      # @example evaluate that :key passes
      #   Asset.new(:key)
      def initialize(*keys)
        super
        @key = keys.first if keys.any?
      end

      def ==(o)
        o.kind_of?(Assert) &&
        o.key == @key
      end

      protected

      def evaluate(obj)
        !!obj
      end

    end
  end
end
