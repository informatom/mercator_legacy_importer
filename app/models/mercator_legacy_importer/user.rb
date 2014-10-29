module MercatorLegacyImporter
  class User < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'ivellio_vellin_customers'
  end
end