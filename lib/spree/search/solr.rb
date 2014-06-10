module Spree
  module Search
    class Solr
      attr_accessor :current_user
      attr_accessor :current_currency

      def initialize(params)
        page = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
        @search_result = Spree::Product.solr_search do
          fulltext params[:keywords]

          # SEARCH BY TAXON
          if params[:taxon].present?
            with(:taxons_ids, params[:taxon])
          end

          # ORDER FILTERS
          if params[:order_by].present?
            order_by params[:order_by].to_sym, params[:order_sort].present? ? params[:order_sort].to_sym : :desc
          end

          Spree::Search::Filters.instance.query_filters.each do |filter|
            # CUSTOM FILTERS
            if params[:s].present? and params[:s][filter.search_param].present?
              any_of do
                params[:s][filter.search_param].each do |p|
                  with(filter.search_param, p.split(',')[0]..p.split(',')[1])
                end
              end
            end

            # FACETING ON FILTERS
            if filter.values.any? && filter.values.first.is_a?(Range)
              facet(filter.search_param) do
                filter.values.each do |value|
                  row(value) do
                    with(filter.search_param, value)
                  end
                end
              end
            else
              facet(
                  filter.search_param
              )
            end
          end
          paginate page: page, per_page: params[:per_page] ||= Spree::Config[:products_per_page]
        end
      end

      def solr_search
        @search_result
      end

      def retrieve_products
        @search_result.results
      end
    end
  end
end