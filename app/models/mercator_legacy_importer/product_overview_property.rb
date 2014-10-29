module MercatorLegacyImporter
  class ProductOverviewProperty < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'product_overview_properties'
  end
end