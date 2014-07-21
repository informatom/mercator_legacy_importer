$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mercator_legacy_importer/version"

Gem::Specification.new do |s|
  s.name        = "mercator_legacy_importer"
  s.version     = MercatorLegacyImporter::VERSION
  s.authors     = ["Stefan Haslinger"]
  s.email       = ["stefan.haslinger@mittenin.at"]
  s.homepage    = "http://mercator.informatom.com"
  s.summary     = "Imports data from legacy MYSQL database."
  s.description = "Sample app for importing data from a legacy MYSQL database."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency 'mysql2'
end
