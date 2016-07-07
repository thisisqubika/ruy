module Ruy
  class UnexpectedObjectError < StandardError; end

  # Wraps an evaluation object and stores lazy variables.
  # It supports hierarchical structures that can be navigated
  # using the #[] method.
  #
  class Context

    attr_reader :obj
    alias_method :object, :obj

    # @param obj
    # @param lets [Array<Symbol>]
    # @example a Hash context
    #   Context.new({key: 5})
    # @example a Hash context and expected lazy variables
    #   Context.new({key: 5}, [:lazy_a, :lazy_b])
    # @example a Fixnum context
    #   Context.new(5)
    def initialize(obj, lets = [])
      @obj = obj
      @lets = lets
      @resolved_lets = {}
    end

    # Returns true if the given key can be resolved in the current context
    #
    # @param key
    #
    # @return [Boolean]
    def include?(key)
      @obj.kind_of?(Hash) && @obj.include?(key)
    end

    # Resolves an attribute key to its corresponding value
    #
    # @param key
    #
    # @return the value
    # @return [nil] if key cannot be resolved
    # @raise UnexpectedObjectError if object in context is not a Hash
    def resolve(key)
      if !@obj.kind_of?(Hash)
        raise UnexpectedObjectError, 'Object in context is not a Hash instance'
      end

      # Lazy variables have precedence over context attributes
      if @lets.include?(key)
        @resolved_lets[key] ||= @obj.instance_exec(&@obj[key])
      else
        @obj[key]
      end
    end

  end
end
