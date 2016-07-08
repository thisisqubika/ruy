require 'time'
require 'tzinfo'

module Ruy
  module Conditions

    # Expects that a Time object's date corresponds to a specified day of
    # the week
    #
    class DayOfWeek < Condition
      DAYS_INTO_WEEK = %w(sunday monday tuesday wednesday thursday friday saturday)

      attr_reader :day, :tz_identifier

      # @param day
      # @param key
      # @param tz_identifier
      # @example to check that the day in 'time' is wednesday
      #   DayOfWeek.new(:wednesday, :time)
      # @example to check that the day in 'time' is wednesday in CST
      #   DayOfWeek.new(:wednesday, :time, 'CST')
      def initialize(day, key, tz_identifier = 'UTC')
        super
        @day = day
        @key = key
        @tz_identifier = tz_identifier
      end

      def ==(o)
        o.kind_of?(DayOfWeek) &&
          o.day == @day &&
          o.key == @key &&
          o.tz_identifier == @tz_identifier
      end

      protected

      # @see Condition#evaluate
      def evaluate(date)
        # Get the TZInfo::Timezone object here so it can be garbage-collected later
        cmp = TZInfo::Timezone.get(@tz_identifier).utc_to_local(date.to_time.utc)

        if @day.is_a?(Fixnum)
          cmp.wday == @day
        else
          DAYS_INTO_WEEK.include?(@day.to_s) && cmp.send("#{@day}?")
        end
      end

    end
  end
end
