module Ruy
  # Context that resolves lets and values access.
  class Context

    attr_reader :values

    # @param [Object] a value or Hash with values
    # @param [Array] symbol names of the 'let' variables
    def initialize(values, lets = [])
      @values = values
      @lets = lets
      @resolved_lets = {}
    end

    # Resolve the given attribute from defined 'let' variables or stored values.
    #
    # @param [Symbol] attr
    #
    # @return [Object]
    # @return [nil] when attribute cannot be resolved
    def resolve(attr)
      if @lets.include?(attr)
        @resolved_lets[attr] ||= @values.instance_exec(&@values[attr])
      else
        @values.fetch(attr) { |key| @values[attr.to_s] }
      end
    end
  end
end
