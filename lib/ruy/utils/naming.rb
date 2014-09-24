module Ruy
  module Utils
    module Naming

      # Returns the simple name of a given module.
      #
      # @example
      #   simple_module_name(Net::HTTP) #=> 'HTTP'
      #
      # @param [Module] mod
      #
      # @return [String]
      # @return [nil] if given module is an anonymous one.
      def self.simple_module_name(mod)
        name = mod.name

        if name
          name.split('::')[-1]
        end
      end

    end
  end
end
