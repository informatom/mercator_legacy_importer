# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:product_relations
  # in Produktivumgebungen: 'bundle exec rake legacy_import:product_relations RAILS_ENV=production'
  desc "Import product relations from legacy webshop"
  task :product_relations => :environment do

    puts "\n\nProductRelations:"

    MercatorLegacyImporter::ProductRelation.all.each do |legacy_product_relation|
      if product = Product.find_by(legacy_id: legacy_product_relation.product_id)
        if related_product = Product.find_by(legacy_id: legacy_product_relation.related_product_id)

          if productrelation = Productrelation.create(product_id: product.id,
                                                   related_product_id: related_product.id)
            print "P"
          else
            puts "\nFAILURE: Productrelation: " + productrelation.errors.first.to_s
          end
        else
          puts "\n FAIILURE: Product not found"
        end
      else
          puts "\n FAIILURE: RelatedProduct not found"
      end
    end
  end
end