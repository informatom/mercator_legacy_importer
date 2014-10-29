module MercatorLegacyImporter
  class CmsNode < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'cms_nodes'

    has_many :cms_node_translations
    has_many :connectors
  end
end