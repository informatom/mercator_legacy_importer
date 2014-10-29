module MercatorLegacyImporter
  class Product < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'products'

    # The following two lines fix the migration issues
    hobo_model
    fields

    has_many :product_translations
    has_many :product_properties
    has_many :properties , :through => :product_properties


    #--- Class Methods --- #

    def self.non_unique
      select("article_number, count(article_number) as quantity").group(:article_number).having("quantity > 1").to_a
    end
  end
end