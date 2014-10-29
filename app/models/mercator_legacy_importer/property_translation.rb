module MercatorLegacyImporter
  class PropertyTranslation < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'property_translations'

    belongs_to :property
    scope :german, -> { where(locale: "de") }
    scope :english, -> { where(locale: "en") }
  end
end