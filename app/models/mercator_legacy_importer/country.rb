module MercatorLegacyImporter
  class Country < ActiveRecord::Base

    establish_connection "import_development"
    self.table_name = 'zones'
  end
end