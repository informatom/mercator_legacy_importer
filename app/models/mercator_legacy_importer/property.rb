module MercatorLegacyImporter
  class Property < ActiveRecord::Base

    establish_connection "legacy_import"
    self.table_name = 'properties'

    # The following two lines fix the migration issues
    hobo_model
    fields

    has_many :property_translations

    has_many :product_properties
    has_many :products, :through => :product_properties
  end
end