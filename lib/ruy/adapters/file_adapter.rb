module Ruy
  module Adapters
    class FileAdapter
      #
      # @param [String] directory
      def initialize(directory)
        @directory = directory
      end

      # Load all the rule files in the directory specified when the adapter
      # was created
      #
      # @return [Array<Ruy::RuleSet]
      def load_rules
        rules = []

        Dir.glob("#{@directory}/*.rb") do |rule_file|
          rule_set = Ruy::RuleSet.new
          rule_set.instance_eval(File.read(rule_file))

          rules << rule_set
        end

        rules
      end
    end
  end
end
