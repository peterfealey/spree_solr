require 'singleton'
module Spree
  module Search
    class Filters
      include Singleton
      attr_accessor :filters

      def initialize
        @filters = []
      end

      def add(&blk)
        filter = Spree::Search::Filter.new
        yield filter
        filter.finalize!
        @filters << filter
      end

      def method_missing(method, *args)
        if @filters.respond_to?(method)
          @filters.send(method, *args)
        else
          super
        end
      end

      def query_filters
        @filters
      end
    end
  end
end