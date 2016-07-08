module Ruy
  module Conditions

    # Evaluates a block using comparison matchers
    # that receive time-related objects with time zone awareness
    #
    # @note Does not support time zone-aware matchers inside sub-blocks.
    #   A workaround for this is always surrounding your
    #   time zone-aware matchers by a 'tz' block even in sub-blocks
    #   already surrounded by one.
    class TZ < CompoundCondition

      # @param tz_identifier [String]
      #   String representing IANA's time zone identifier.
      # @example evaluate all the sub-conditions under CST
      #   TZ.new('CST')
      def initialize(tz_identifier)
        super
        @tz_identifier = tz_identifier
      end

      # @see Ruy::Conditions::DayOfWeek#initialize
      def day_of_week(dow, key)
        conditions << DayOfWeek.new(dow, key, @tz_identifier)
      end

      # @see Ruy::Conditions::Eq#initialize
      def eq(pattern, *key)
        super(TimePattern.new(pattern, @tz_identifier), *key)
      end


      # @see Ruy::Conditions::GreaterThanOrEqual#initialize
      def greater_than(pattern, *key)
        super(TimePattern.new(pattern, @tz_identifier), *key)
      end

      # @see Ruy::Conditions::GreaterThanOrEqual#initialize
      def greater_than_or_equal(pattern, *key)
        super(TimePattern.new(pattern, @tz_identifier), *key)
      end

      # @see Ruy::Conditions::LessThan#initialize
      def less_than(pattern, *key)
        super(TimePattern.new(pattern, @tz_identifier), *key)
      end

      # @see Ruy::Conditions::LessThanOrEqual#initialize
      def less_than_or_equal(pattern, *key)
        super(TimePattern.new(pattern, @tz_identifier), *key)
      end

      # @see Ruy::Conditions::Between#initialize)
      def between(from, to, *key)
        super(TimePattern.new(from, @tz_identifier),
          TimePattern.new(to, @tz_identifier), *key)
      end

    end
  end
end
