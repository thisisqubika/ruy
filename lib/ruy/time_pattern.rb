require 'tzinfo'

module Ruy
  class TimePattern
    include Comparable

    WELL_FORMED_TS_EXP = /^(?<year>\d{4}|\*)-(?<month>\d{2}|\*)-(?<day>\d{2}|\*)T(?<hour>\d{2}|\*):(?<minute>\d{2}|\*):(?<second>\d{2}|\*)(z(?<time_zone>\S+))?$/

    attr_reader :year, :month, :day, :hour, :min, :sec, :time_zone, :tz, :local, :utc, :utc_offset

    # @param [String] pattern String representing a Ruy's well-formed timestamp pattern
    # @param [String] tz_identifier String representing IANA's time zone identifier. Defaults to UTC if none passed.
    def initialize(pattern, tz_identifier = 'UTC')
      raise ArgumentError, 'Pattern is malformed' unless match_data = pattern.match(WELL_FORMED_TS_EXP)

      @pattern = pattern

      @year = match_data[:year] == '*' ? nil : match_data[:year].to_i
      @month = match_data[:month] == '*' ? nil : match_data[:month].to_i
      @day = match_data[:day] == '*' ? nil : match_data[:day].to_i
      @hour = match_data[:hour] == '*' ? nil : match_data[:hour].to_i
      @min = match_data[:minute] == '*' ? nil : match_data[:minute].to_i
      @sec = match_data[:second] == '*' ? nil : match_data[:second].to_i
      @time_zone = match_data[:time_zone]

      # Store the TZInfo::Timezone object corresponding to the specified time zone
      @tz = TZInfo::Timezone.get(@time_zone || tz_identifier)

      # Store a Time object with values based on the specified time zone
      @local = Time.new(year || 0, month, day, hour, min, sec, '+00:00')

      # Store a Time object with values based on UTC
      @utc = @tz.local_to_utc(@local)
      @utc_offset = @tz.current_period.utc_total_offset
    end

    # Implements Ruby's spaceship operator to work with Time objects.
    #   Uses Object's spaceship operator if passed object does not respond to #to_time.
    #
    # @param [#to_time]
    # @return [Fixnum]
    def <=>(o)
      if o.respond_to?(:to_time)
        time = o.to_time
        time_to_local = @tz.utc_to_local(time.utc)

        self_time = Time.gm(
          self.year  || time_to_local.year,
          self.month || time_to_local.month,
          self.day   || time_to_local.day,
          self.hour  || time_to_local.hour,
          self.min   || time_to_local.min,
          self.sec   || time_to_local.sec,
          Rational(time_to_local.nsec, 1000)
          )

        @tz.local_to_utc(self_time) <=> time

      else
        super
      end
    end

    # Overrides Object equal operator and uses Comparable equality for Time objects.
    #   Uses identity comparison if passed object does not respond to #to_time.
    #
    # @param [#to_time]
    # @return [Boolean]
    def ==(o)
      if o.is_a?(self.class)
        return year == o.year &&
          month == o.month &&
          day == o.day &&
          hour == o.hour &&
          min == o.min &&
          sec == o.sec &&
          time_zone == o.time_zone
      elsif o.respond_to?(:to_time)
        super
      else
        equal?(o)
      end
    end

    # Returns a well-formed Ruy timestamp with IANA time zone identifier representing the current TimePattern object.
    #
    # @return [String]
    def to_s
      @pattern
    end

    # Overrides Ruby's method missing call to redirect calls to the stored Time object in case it responds to the
    #   missing method. Will call to super in case it doesn't.
    #
    # @param (see BasicObject#method_missing)
    def method_missing(method, *args)
      @utc.respond_to?(method) ? @utc.send(method, *args) : super
    end

  end
end
