module MercatorLegacyImporter
  class CmsNodeTranslation < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'cms_node_translations'

    belongs_to :cms_node
    scope :german, -> { where(locale: "de") }
    scope :english, -> { where(locale: "en") }
  end
end