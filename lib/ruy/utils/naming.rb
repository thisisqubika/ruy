module Ruy
  module Utils
    module Naming

      # Returns the simple name of a given module.
      #
      # @example
      #   simple_module_name(Net::HTTP) # => 'HTTP'
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

      # Converts a string into a snake case representation.
      #
      # It suppports these kinds of strings:
      #  - camel case
      #  - all caps
      #  - camel case mixed with all caps
      #
      # @param [String] s
      #
      # @return [String]
      def self.snakecase(s)
        s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
         .gsub(/([a-z\d])([A-Z])/,'\1_\2')
         .downcase
      end

      # Returns the name of a rule object.
      #
      # @example
      #   rule_name(Ruy::Eq.new) # => 'eq'
      #
      # @param [Ruy::Rule] rule
      #
      # @return [String]
      def self.rule_name(rule)
        module_name = simple_module_name(rule.class)

        snakecase(module_name)
      end
    end
  end
end
