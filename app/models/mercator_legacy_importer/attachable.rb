module MercatorLegacyImporter
  class Attachable < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'attachables'

    belongs_to :asset
  end
end