module Ruy
  module Conditions

    class Condition
      include Ruy::DSL

      attr_reader :params

      def initialize(*params)
        @params = params
      end

    end
  end
end
