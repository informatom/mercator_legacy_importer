module MercatorLegacyImporter
  class Asset < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'assets'
  end
end