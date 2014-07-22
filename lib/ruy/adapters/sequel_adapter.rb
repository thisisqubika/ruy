require 'sequel'
require 'json'

module Ruy
  module Adapters
    class SequelAdapter
      def initialize(connection_data)
        @db = initialize_connection(connection_data)
      end

      # Load all the rule objects in the specified database.
      #
      # @return [Array<Ruy::RuleSet>]
      def load_rules(params = {})
        options = { rules_table: 'event_rules',
          serialized_data_column: 'data' }.merge(params)

        dataset = @db[options[:rules_table]].all
        dataset.collect do |row|
          rule_set = Ruy::RuleSet.from_hash(
            JSON.parse(row[options[:serialized_data_column]], symbolize_names: true)
          )

          yield row, rule_set if block_given?
          rule_set
        end
      end

      private
      #
      # @param [Hash] connection_data
      # @return []
      def initialize_connection(connection_data)
        Sequel.connect(adapter: connection_data[:adapter],
          host: connection_data[:host], database: connection_data[:database],
          user: connection_data[:user], password: connection_data[:password])
      end
    end
  end
end
