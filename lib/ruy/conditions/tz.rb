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
      
      # @param [String] tz_identifier
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
      def eq(pattern, *keys)
        super(TimePattern.new(pattern, @tz_identifier), *keys)
      end


      # @see Ruy::Conditions::GreaterThanOrEqual#initialize
      def greater_than(pattern, *keys)
        super(TimePattern.new(pattern, @tz_identifier), *keys)
      end

      # @see Ruy::Conditions::GreaterThanOrEqual#initialize
      def greater_than_or_equal(pattern, *keys)
        super(TimePattern.new(pattern, @tz_identifier), *keys)
      end

      # @see Ruy::Conditions::LessThan#initialize
      def less_than(pattern, *keys)
        super(TimePattern.new(pattern, @tz_identifier), *keys)
      end

      # @see Ruy::Conditions::LessThanOrEqual#initialize
      def less_than_or_equal(pattern, *keys)
        super(TimePattern.new(pattern, @tz_identifier), *keys)
      end

      # @see Ruy::Conditions::Between#initialize)
      def between(from, to, *keys)
        super(TimePattern.new(from, @tz_identifier),
          TimePattern.new(to, @tz_identifier), *keys)
      end

    end
  end
end
