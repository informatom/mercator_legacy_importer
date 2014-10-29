module MercatorLegacyImporter
  class ProductTranslation < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'product_translations'

    belongs_to :product
    scope :german, -> { where(locale: "de") }
    scope :english, -> { where(locale: "en") }
  end
end