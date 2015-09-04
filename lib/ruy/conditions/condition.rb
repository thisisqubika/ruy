module Ruy
  module Conditions

    class Condition
      include Ruy::DSL

      attr_reader :conditions
      attr_reader :params

      def initialize(*params)
        @params = params

        @conditions = []
      end

      # Evaluates all conditions.
      #
      # @return [true] When all conditions succeeds
      # @return [false] Otherwise
      def call(ctx)
        @conditions.all? do |condition|
          condition.call(ctx)
        end
      end
    end
  end
end
