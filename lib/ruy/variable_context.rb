module Ruy
  # Context that can resolve variable access
  class VariableContext
    def initialize(ctx, vars)
      @ctx = ctx
      @vars = vars

      @resolved_vars = {}
    end

    # Resolve the given attr from the variables or the context
    # If attribute can't be resolved then throw an exception
    #
    # @param [Symbol] attr
    # @return [Object]
    def resolve(attr)
      if @vars.include?(attr)
        @resolved_vars[attr] ||= @ctx.instance_exec(&@vars[attr])
      else
        @ctx.fetch(attr) { |key| @ctx[key.to_s] }
      end
    end
  end
end
