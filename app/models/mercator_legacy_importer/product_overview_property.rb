module MercatorLegacyImporter
  class ProductOverviewProperty < ActiveRecord::Base

    establish_connection "import_development"
    self.table_name = 'product_overview_properties'
  end
end