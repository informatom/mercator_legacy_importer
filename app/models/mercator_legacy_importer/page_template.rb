module MercatorLegacyImporter
  class PageTemplate < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'page_templates'

    # The following two lines fix the migration issues
    hobo_model
    fields
  end
end