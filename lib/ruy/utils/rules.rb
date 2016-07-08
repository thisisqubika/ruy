module Ruy
  module Utils
    module Rules

      # Evaluates conditions against the given context
      #
      # Returns true when all the conditions match, false otherwise.
      #
      # @param conditions [Array<Condition>]
      # @param ctx [Context]
      #
      # @return [Boolean]
      def self.evaluate_conditions(conditions, ctx)
        succeed_conditions = conditions.take_while do |condition|
          condition.call(ctx)
        end

        succeed_conditions.length == conditions.length
      end

      # Returns the value of the first outcome that matches
      #
      # @param ctx [Ruy::Context]
      #
      # @return [Object] The value of the first matching outcome
      # @return [nil] when no outcome matches
      def self.compute_outcome(outcomes, ctx)
        outcomes.each do |outcome|
          result = outcome.call(ctx)
          unless result.nil?
            return result
          end
        end

        nil
      end

    end
  end
end
