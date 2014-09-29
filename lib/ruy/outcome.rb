module Ruy
  class Outcome < Rule
    attr_reader :value

    def initialize(value)
      super
      @value = value
    end

    def call(ctx)
      if super(ctx)
        @value
      end
    end

    def ==(o)
      o.kind_of?(Outcome) &&
        value == o.value &&
        conditions == o.conditions
    end
  end
end
