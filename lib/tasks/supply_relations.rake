# encoding: utf-8

# Probably not to be used because of Icecat import !

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:supply_relations RAILS_ENV=production'
  desc "Import supply_relations from legacy webshop"
  task :supply_relations => :environment do

    puts "\n\nSupplyRelations:"

    MercatorLegacyImporter::ProductSupply.all.each do |legacy_product_supply|
      if product = Product.find_by(legacy_id: legacy_product_supply.product_id)
        if supply = Product.find_by(legacy_id: legacy_product_supply.supply_id)

          if supplyrelation = Supplyrelation.create(product_id: product.id,
                                                    supply_id: supply.id)
            print "S"
          else
            puts "\nFAILURE: Supplyrelation: " + supplyrelation.errors.first.to_s
          end
        else
          puts "\n FAIILURE: Product not found"
        end
      else
          puts "\n FAIILURE: Supply not found"
      end
    end
  end
end