require 'time'
require 'tzinfo'

module Ruy
  module Conditions

    # Expects that a Time object's date corresponds to a specified day of the week
    class DayOfWeek < Ruy::Rule
      attr_reader :attr, :value, :tz_identifier

      # @param attr
      # @param value
      # @param tz_identifier
      def initialize(attr, value, tz_identifier = 'UTC')
        super()

        @attr = attr
        @value = value
        @tz_identifier = tz_identifier
        @params = [@attr, @value, @tz_identifier]

        @tz = TZInfo::Timezone.get(tz_identifier)
      end

      # @param [Ruy::VariableContext] var_ctx
      def call(var_ctx)
        resolved = var_ctx.resolve(@attr)
        time = resolved.is_a?(Time) ? resolved : Time.parse(resolved)
        cmp = @tz.utc_to_local(time.utc)

        if @value.is_a?(Fixnum)
          cmp.wday == @value
        else
          cmp.send("#{@value}?")
        end
      end

      # @param o
      def ==(o)
        o.kind_of?(DayOfWeek) &&
          attr == o.attr &&
          value == o.value &&
          tz_identifier == o.tz_identifier
      end
    end
  end
end
