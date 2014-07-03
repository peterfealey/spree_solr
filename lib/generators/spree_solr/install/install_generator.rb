if not defined?(SunspotRails::Generators::InstallGenerator)
  require 'generators/sunspot_rails/install/install_generator.rb'
end
module SpreeSolr
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def invoke_sunspot_rails_generator
        SunspotRails::Generators::InstallGenerator.start
      end

      def add_initializer
        template "config/initializers/spree_solr.rb"
        template "config/initializers/string.rb"
      end
    end
  end
end
