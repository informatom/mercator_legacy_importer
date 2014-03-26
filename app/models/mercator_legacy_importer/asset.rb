module MercatorLegacyImporter
  class Asset < ActiveRecord::Base

    establish_connection "import_development"
    self.table_name = 'assets'
  end
end