module MercatorLegacyImporter
  class ProductSupply < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'product_supplies'
  end
end