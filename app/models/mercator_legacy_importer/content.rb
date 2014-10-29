module MercatorLegacyImporter
  class Content < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'contents'

    has_many :connectors
  end
end