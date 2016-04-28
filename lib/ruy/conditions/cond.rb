module Ruy
  module Conditions

    # Evaluates any given number of sub-conditions in subsequent pairs
    # until one pair evaluates succesfully.
    # If an uneven number of conditions is given, it will evaluate in pairs
    # except for the last condition which will be evaluated alone.
    #
    class Cond < CompoundCondition

      protected

      def evaluate(ctx)
        clauses = conditions.each_slice(2)

        clauses.any? do |rule_1, rule_2|
          result = rule_1.call(ctx)

          if rule_2
            result && rule_2.call(ctx)
          else
            result
          end
        end
      end

    end

  end
end
