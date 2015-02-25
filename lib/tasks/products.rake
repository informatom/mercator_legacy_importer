# encoding: utf-8
require 'string_extensions'

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:products RAILS_ENV=production'
  desc "Import products from legacy webshop"
  task :products => :environment do
    puts "\n\nProducts:"
    Product.all.each do |product|
      product.delete
    end
    print "Products deleted."

    MercatorLegacyImporter::Product.all.each do |legacy_product|
      legacy_product_de = legacy_product.product_translations.german.first
      legacy_product_en = legacy_product.product_translations.english.first

      if legacy_product_de && legacy_product_de.title.present?
        title_de = legacy_product_de.title
      else
        title_de = legacy_product.name
      end

      if legacy_product_de && legacy_product_de.long_description.present?
        description_de = legacy_product_de.long_description
      else
        description_de = "fehlt"
      end

      if legacy_product_en && legacy_product_en.title.present?
        title_en = legacy_product_en.title
      else
        title_en = legacy_product.name
      end

      if legacy_product_en && legacy_product_en.long_description.present?
        description_en = legacy_product_en.long_description
      else
        description_en = "missing"
      end

      product = Product.create(number: legacy_product.article_number,
                               title_de: title_de,
                               title_en: title_en,
                               description_de: description_de,
                               description_en: description_en,
                               legacy_id: legacy_product.id)
      if product.save
        print "P"
      else
        product.number = legacy_product.id.to_s + " - Duplikat von " + legacy_product.article_number
        if product.save
          print "P"
        else
          puts "\nFAILURE: Product " + legacy_product.article_number + ": " + product.errors.first.to_s
        end
      end
    end
  end
end