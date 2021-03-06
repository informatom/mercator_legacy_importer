# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:product_images RAILS_ENV=production'
  desc "Import product_images from legacy webshop"
  task :product_images => :environment do

    require 'net/http'
    puts "\n\nProduct Images:"

    Net::HTTP.start("www.iv-shop.at") do |http|
      MercatorLegacyImporter::Product.all.each do |legacy_product|
        unless legacy_product.image_file_name || legacy_product.overview_file_name
          print "x"
          next
        end

        product = Product.find_by_legacy_id(legacy_product.id)
        if product.photo_file_name.present?
          print "✔"
          next
        end

        filename = "/system/images/" + legacy_product.id.to_s +
                            "/original/" + legacy_product.image_file_name.presence ||
                                           legacy_product.overview_file_name
        data = StringIO.new(http.get(filename).body)
        data.class.class_eval { attr_accessor :original_filename }
        data.original_filename = legacy_product.image_file_name.presence || legacy_product.overview_file_name
        product.photo = data
        product.photo_content_type = MIME::Types.type_for(data.original_filename).first.content_type

        if product.save
          print "P"
        else
          puts "\nFAILURE: Image: " + product.errors.first.to_s
          # If image is missing on server, we get probable a content type mismatch error, e.g. html (error page) instead of png (image)
        end
      end
    end
  end
end