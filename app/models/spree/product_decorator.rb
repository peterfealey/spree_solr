module Spree
  Product.class_eval do

    #SOLR
    searchable :if => :indexable? do
      text :name, :boost => 5.0, :more_like_this => true
      text :description, :boost => 3.0, :more_like_this => true
      text :taxon_names_text do
        taxon_names.join(',')
      end
      time :available_on
      time :updated_at
      double :price
      string :name
      string :taxon_names, :multiple => true
      integer :taxons_ids, :multiple => true
      integer :id
    end

    Facets = %w(
        taxon_names
        price
      )

    def indexable?
      available?
    end

    def taxons_ids
      taxons.map(&:self_and_ancestors).flatten.uniq.map(&:id)
    end

    def taxon_names
      taxons.map(&:self_and_ancestors).flatten.uniq.map(&:name)
    end

    def properties_text
      product_properties.map { |pp| "#{pp.property.name}||#{pp.value}" } if product_properties.present?
    end
  end
end