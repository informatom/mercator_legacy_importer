# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:unlinked_content_items RAILS_ENV=production'
  desc "Import unlinked_content_items from legacy webshop"
  task :unlinked_content_items => :environment do

    puts "\n\nUnlinked Content Items:"

    MercatorLegacyImporter::ContentItem.where(typ: "text").each do |legacy_content_item|

      content_element = ContentElement.find_or_initialize_by(content_de: legacy_content_item.value)

      if legacy_content_item.content
        name = legacy_content_item.content.name
      else
        name =  "unbekannt"
      end
      content_element.name_de = name
      content_element.markup = "html"

      if content_element.save
        print "C"
        legacy_content_item.content.delete() if legacy_content_item.content
        legacy_content_item.delete()
      else
        puts "\nFAILURE: ContentElement: " + content_element.errors.first.to_s
      end
    end
  end
end