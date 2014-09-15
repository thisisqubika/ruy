require 'tzinfo'

module Ruy
  class TimePattern
    include Comparable

    WELL_FORMED_TS_EXP = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(z(\S+))?$/

    attr_reader :tz, :local_time, :utc_time

    # @param [String] pattern String representing a Ruy's well-formed timestamp pattern
    # @param [String] tz_identifier String representing IANA's time zone identifier. Defaults to UTC if none passed.
    def initialize(pattern, tz_identifier = 'UTC')
      raise ArgumentError, 'Pattern is malformed' unless match_data = pattern.match(WELL_FORMED_TS_EXP)

      year = match_data[1].to_i
      month = match_data[2].to_i
      day = match_data[3].to_i
      hours = match_data[4].to_i
      min = match_data[5].to_i
      sec = match_data[6].to_i
      tz_identifier = match_data[8] || tz_identifier

      # Store the TZInfo::Timezone object corresponding to the specified time zone
      @tz = TZInfo::Timezone.get(tz_identifier)

      # Store a Time object with values based on the specified time zone
      @local_time = Time.new(year, month, day, hours, min, sec, '+00:00')

      # Store a Time object with values based on UTC
      @utc_time = @tz.local_to_utc(@local_time)
    end

    # Implements Ruby's spaceship operator to work with TimePattern objects.
    #
    # @param [TimePattern|Time]
    # @return [Fixnum]
    def <=>(time)
      @utc_time <=> (time.is_a?(self.class) ? time.utc_time : time)
    end

    # Returns a well-formed Ruy timestamp with IANA time zone identifier representing the current TimePattern object.
    #
    # @return [String]
    def to_s
      @local_time.strftime("%Y-%m-%dT%H:%M:%Sz#{@tz.identifier}")
    end

    # Overrides Ruby's method missing call to redirect calls to the stored Time object in case it responds to the
    #   missing method. Will call to super in case it doesn't.
    #
    # @param (see BasicObject#method_missing)
    def method_missing(method, *args)
      @utc_time.respond_to?(method) ? @utc_time.send(method, *args) : super
    end
  end
end
