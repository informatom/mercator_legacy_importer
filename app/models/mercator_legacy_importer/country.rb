module MercatorLegacyImporter
  class Country < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'zones'
  end
end