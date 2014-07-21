# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:categorizations
  # in Produktivumgebungen: 'bundle exec rake legacy_import:categorizations RAILS_ENV=production'
  desc "Import categorizations from legacy webshop"
  task :categorizations => :environment do

    puts "\n\nCategorizations:"
    MercatorLegacyImporter::Product.all.each do |legacy_product|

      unless product = Product.find_by_legacy_id(legacy_product.id) then
        puts "\nFAILURE: Product " + legacy_product.id.to_s + " not found."
        next
      end

      if legacy_product.article_group && legacy_product.article_group.length == 11
        legacy_product.article_group = "00" + legacy_product.article_group[0..3] +
                                       "00" + legacy_product.article_group[4..7] +
                                       "00" + legacy_product.article_group[8..10] +
                                       "-00000-00000"
      end

      unless legacy_category = MercatorLegacyImporter::Category.find_by_category_product_group(legacy_product.article_group) then
        puts "\nFAILURE: Legacy Category " + legacy_product.article_group.to_s + " not found."
        next
      end

      unless  category = Category.find_by_legacy_id(legacy_category.id) then
        puts "\nFAILURE: Category " + legacy_category.id.to_s + " not found."
        next
      end

      categorization = Categorization.find_or_initialize_by_product_id_and_category_id(product.id, category.id)
      unless categorization.update_attributes(position: 1) then
        puts "\nFAILURE: Categorization " + categorization.errors.first.to_s
        next
      end

      print "…"
    end
  end
end