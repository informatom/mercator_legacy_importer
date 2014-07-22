# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:product_images
  # in Produktivumgebungen: 'bundle exec rake legacy_import:product_images RAILS_ENV=production'
  desc "Import product_images from legacy webshop"
  task :product_images => :environment do

    require 'net/http'
    puts "\n\nProduct Images:"

    Net::HTTP.start("www.iv-shop.at") do |http|
      MercatorLegacyImporter::Product.all.each do |legacy_product|
        unless legacy_product.image_file_name || legacy_product.overview_file_name
          print "."
          next
        end

        product = Product.find_by_legacy_id(legacy_product.id)
        if product.filename
          print "x"
          next
        end

        filename = "/system/images/" + legacy_product.id.to_s +
                            "/original/" + legacy_product.image_file_name.presence ||
                                           legacy_product.overview_file_name
        data = StringIO.new(http.get(filename).body)
        data.class.class_eval { attr_accessor :original_filename }
        data.original_filename = legacy_product.image_file_name.presence || legacy_product.overview_file_name
        product.photo = data
        if product.save
          print "P"
        else
          puts "\nFAILURE: Image: " + product.errors.first.to_s
        end

      end
    end
  end
end