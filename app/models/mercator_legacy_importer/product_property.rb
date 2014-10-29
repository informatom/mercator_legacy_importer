module MercatorLegacyImporter
  class ProductProperty < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'products_properties'

    belongs_to :product
    belongs_to :property
  end
end