module Ruy
  module Conditions

    # Evaluates a block using comparison matchers that receive time-related objects with time zone awareness.
    #   Does not support time zone-aware matchers inside sub-blocks.
    #   A workaround for this is always surrounding your time zone-aware matchers by a 'tz' block even in sub-blocks
    #   already surrounded by one.
    class TZ < Ruy::Rule
      # @param [String] tz_identifier String representing IANA's time zone identifier.
      def initialize(tz_identifier)
        super
        @tz_identifier = tz_identifier
      end

      # @param [Ruy::VariableContext] var_ctx
      def call(var_ctx)
        @conditions.all? do |condition|
          condition.call(var_ctx)
        end
      end

      # Adds a DayOfWeek condition
      #
      # @param (see Ruy::Conditions::DayOfWeek#initialize)
      def day_of_week(attr, dow)
        @conditions << DayOfWeek.new(attr, dow, @tz_identifier)
      end

      # Intercepts an 'eq' call to the superclass and enhances its arguments
      #
      # @param (see Ruy::Conditions::Eq#initialize)
      def eq(attr, pattern, &block)
        super(attr, TimePattern.new(pattern, @tz_identifier), &block)
      end

      # TODO Add Greater condition call here

      # Intercepts a 'greater_than_or_equal' call to the superclass and enhances its arguments
      #
      # @param (see Ruy::Conditions::GreaterThanOrEqual#initialize)
      def greater_than_or_equal(attr, pattern, &block)
        super(attr, TimePattern.new(pattern, @tz_identifier), &block)
      end

      # Intercepts a 'less_than' call to the superclass and enhances its arguments
      #
      # @param (see Ruy::Conditions::LessThan#initialize)
      def less_than(attr, pattern, &block)
        super(attr, TimePattern.new(pattern, @tz_identifier), &block)
      end

      # Intercepts a 'less_than_or_equal' call to the superclass and enhances its arguments
      #
      # @param (see Ruy::Conditions::LessThanOrEqual#initialize)
      def less_than_or_equal(attr, pattern, &block)
        super(attr, TimePattern.new(pattern, @tz_identifier), &block)
      end

      # Intercepts a 'between' call to the superclass and enhances its arguments
      #
      # @param (see Ruy::Conditions::Between#initialize)
      def between(attr, from, to, &block)
        super(attr, TimePattern.new(from, @tz_identifier), TimePattern.new(to, @tz_identifier), &block)
      end

    end
  end
end
