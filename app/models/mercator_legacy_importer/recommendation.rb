module MercatorLegacyImporter
  class Recommendation < ActiveRecord::Base
    establish_connection "legacy_import"
    self.table_name = 'recommendations'

    # The following two lines fix the migration issues
    hobo_model
    fields

    has_many :recommendation_translations
  end
end