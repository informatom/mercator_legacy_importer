# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:name
  # in Produktivumgebungen: 'bundle exec rake legacy_import:name RAILS_ENV=production'
  desc "Import name from legacy webshop"
  task :name => :environment do

  end
end

#  import_categories()
#  import_products()
#  import_properties()
#  import_features()
#  import_categorizations()
#  import_product_images()
#  import_product_relations()
#  import_supply_relations()
#  import_recommendations()
#  import_page_templates()
#  import_pages()
#  import_content_elements()
#  import_category_images()
#  import_cms_node_images()
#  import_unlinked_content_items()
#  import_remaining_images()
#  import_remaining_assets()