module Ruy
  # Context that resolves lets and values access
  class Context

    # @param [Hash] ctx
    # @param [Array] lets
    def initialize(ctx, lets = [])
      @ctx = ctx
      @lets = lets

      @resolved_lets = {}
    end

    # Resolve the given attr from the lets or the context
    # If attribute can't be resolved then throw an exception
    #
    # @param [Symbol] attr
    #
    # @return [Object]
    def resolve(attr)
      if @lets.include?(attr)
        @resolved_lets[attr] ||= @ctx.instance_exec(&@ctx[attr])
      else
        @ctx.fetch(attr) { |key| @ctx[key.to_s] }
      end
    end
  end
end
