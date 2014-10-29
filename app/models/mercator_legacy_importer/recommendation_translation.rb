module MercatorLegacyImporter
  class RecommendationTranslation < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'recommendation_translations'

    belongs_to :recommendation
    scope :german, -> { where(locale: "de") }
    scope :english, -> { where(locale: "en") }
  end
end