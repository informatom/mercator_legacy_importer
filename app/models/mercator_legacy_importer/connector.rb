module MercatorLegacyImporter
  class Connector < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'connectors'

    belongs_to :content
    belongs_to :cms_node
  end
end