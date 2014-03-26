Rails.application.routes.draw do

  mount MercatorLegacyImporter::Engine => "/mercator_legacy_importer"
end
