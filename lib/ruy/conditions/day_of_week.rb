require 'time'
require 'tzinfo'

module Ruy
  module Conditions

    # Expects that a Time object's date corresponds to a specified day of the week.
    class DayOfWeek < Condition
      DAYS_INTO_WEEK = %w(sunday monday tuesday wednesday thursday friday saturday)

      attr_reader :day, :attr, :tz_identifier

      # @param day
      # @param attr
      # @param tz_identifier
      def initialize(day, attr, tz_identifier = 'UTC')
        super
        @day = day
        @attr = attr
        @tz_identifier = tz_identifier
      end

      def ==(o)
        o.kind_of?(DayOfWeek) &&
          o.day == @day &&
          o.attr == @attr &&
          o.tz_identifier == @tz_identifier
      end

      protected

      def evaluate(value)
        # Get the TZInfo::Timezone object here so it can be garbage-collected later
        cmp = TZInfo::Timezone.get(@tz_identifier).utc_to_local(value.to_time.utc)

        if @day.is_a?(Fixnum)
          cmp.wday == @day
        else
          DAYS_INTO_WEEK.include?(@day.to_s) && cmp.send("#{@day}?")
        end
      end

    end
  end
end
