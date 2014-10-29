module MercatorLegacyImporter
  class ContentItem < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'content_items'

    belongs_to :content
  end
end