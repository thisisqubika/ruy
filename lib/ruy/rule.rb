module Ruy
  class Rule
    include DSL
    include Utils::Printable

    attr_reader :conditions

    def initialize(*args)
      @attrs = {}
      @conditions = []

      @params = args
    end

    # Gets attribute's value from the given name.
    #
    # @param name
    #
    # @return The attribute's value.
    def get(name)
      @attrs[name]
    end

    # Sets a custom attribute.
    #
    # @param name Attribute's name
    # @param value Attribute's value
    def set(name, value)
      @attrs[name] = value
    end

    # Evaluates all conditions.
    #
    # @return [true] When all conditions succeeds
    # @return [false] Otherwise
    def call(ctx)
      success = @conditions.take_while do |condition|
        condition.call(ctx)
      end

      success.length == @conditions.length
    end

    def ==(o)
      o.kind_of?(Rule) &&
        conditions == o.conditions
    end

    # Getter method for rules params. It returns all the params without nil objects.
    #
    # @return [Array<Object>]
    def params
      @params.compact
    end
  end
end
