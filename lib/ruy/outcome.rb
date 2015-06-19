module Ruy
  class Outcome
    include DSL

    attr_reader :value

    def initialize(value)
      @value = value
      @rule = Ruy::Rule.new
    end

    def call(ctx)
      if @rule.call(ctx)
        @value
      end
    end

    def conditions
      @rule.conditions
    end

    def params
      [@value]
    end

    def ==(o)
      o.kind_of?(Outcome) &&
        value == o.value &&
        conditions == o.conditions
    end
  end
end
