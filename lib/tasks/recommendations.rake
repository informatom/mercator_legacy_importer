# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:recommendations
  # in Produktivumgebungen: 'bundle exec rake legacy_import:recommendations RAILS_ENV=production'
  desc "Import recommendations from legacy webshop"
  task :recommendations => :environment do
    puts "\n\nRecommendations:"

    MercatorLegacyImporter::Recommendation.all.each do |legacy_recommendation|
      legacy_reason_de = legacy_recommendation.recommendation_translations.german.first
      legacy_reason_en = legacy_recommendation.recommendation_translations.english.first

      next if legacy_recommendation.from_product_id.nil?
      if product = Product.find_by(legacy_id: legacy_recommendation.from_product_id)
        next if legacy_recommendation.for_product_id.blank?
        if recommendation = Product.find_by(number: legacy_recommendation.for_product_id)
          reason_de = legacy_reason_de.description.fix_utf8
          reason_en = legacy_reason_en.description.fix_utf8

          if reason_de.include? 'schnellerer Druck'
            debugger
          end

          if recommendation = Recommendation.create(product_id: product.id,
                                                    recommended_product_id: recommendation.id,
                                                    reason_de: reason_de,
                                                    reason_en: reason_en)
            print "R"
          else
            puts "\nFAILURE: Recommendation: " + recommendation.errors.first.to_s
          end
        else
          puts "\n FAIILURE: Recommended product not found: " + legacy_recommendation.for_product_id
        end
      else
        puts "\n FAIILURE: Product not found: " + legacy_recommendation.from_product_id.to_s
      end
    end
  end
end