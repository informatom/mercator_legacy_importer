module MercatorLegacyImporter
  class ProductRelation < ActiveRecord::Base

    establish_connection "import_development"
    self.table_name = 'product_relations'
  end
end