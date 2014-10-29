module MercatorLegacyImporter

  class Category < ActiveRecord::Base
    establish_connection "legacy_import"
    self.table_name = 'categories'

    # The following two lines fix the migration issues
    hobo_model
    fields

    has_many :category_translations
  end
end