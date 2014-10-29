module MercatorLegacyImporter
  class CategoryTranslation < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'category_translations'

    belongs_to :category
    scope :german, -> { where(locale: "de") }
    scope :english, -> { where(locale: "en") }
  end
end