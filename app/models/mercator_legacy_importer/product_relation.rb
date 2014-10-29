module MercatorLegacyImporter
  class ProductRelation < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'product_relations'
  end
end