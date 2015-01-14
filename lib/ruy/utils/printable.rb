require 'pp'
require 'stringio'

module Ruy
  module Utils

    module Printable

      INDENTATION = ' ' * 2

      def self.indent(level)
        INDENTATION * level
      end

      # Adds inspect compatibility on ruby 1.9
      #
      # Ruby 1.9 changed the behaviour of #inspect, when not overriden, it uses #to_s method to
      # generate the string.
      #
      # Since Ruby 2.0, the original behaviour was restored.
      #
      # @see https://bugs.ruby-lang.org/issues/4453
      def inspect
        PP.singleline_pp(self, StringIO.new).string
      end

      # Adds pretty print compatibility on ruby 1.9
      #
      # @see https://bugs.ruby-lang.org/issues/4453
      def pretty_print(pp)
        pp.pp_object(self)
      end

    end
  end
end
