# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:content_elements
  # in Produktivumgebungen: 'bundle exec rake legacy_import:content_elements RAILS_ENV=production'
  desc "Import content_elements from legacy webshop"
  task :content_elements => :environment do
    puts "\n\nContent Elements:"
    @legacy_contents = []

    MercatorLegacyImporter::CmsNode.where(name: ["main", "overview", "slogan"]).each do |legacy_cms_node|

      page = Page.where(legacy_id: legacy_cms_node.parent_id).first

      legacy_cms_node.connectors.each do |legacy_connector|
        if legacy_connector.position != 1
          @used_as = legacy_cms_node.name + legacy_connector.position.to_s
        else
          @used_as = legacy_cms_node.name
        end

        @locale = legacy_connector.locale
        legacy_content = legacy_connector.content
        legacy_id = legacy_cms_node.id

        content_element = ContentElement.find_or_initialize_by(legacy_id: legacy_id)
        content_element.markup = "html"
        content_element.name_de = legacy_content.name if @locale == "de"
        content_element.name_en = legacy_content.name if @locale == "en"

        MercatorLegacyImporter::ContentItem.where(content_id: legacy_content.id).each do |legacy_content_item|
          content_element.content_de = legacy_content_item.value if @locale == "de"
          content_element.content_en = legacy_content_item.value if @locale == "en"
        legacy_content_item.delete()
        end

        if content_element.save
          print "C"
        else
          puts "\nFAILURE: ContentElement: " + content_element.errors.first.to_s
        end

        pcea = PageContentElementAssignment.find_or_initialize_by(used_as: @used_as,
                                                                  page_id: page.id,
                                                                  content_element_id: content_element.id)
        if pcea.save
          print "A"
        else
          puts "\nFAILURE: PageContentElementAssignment: " + pcea.errors.first.to_s
        end

        @legacy_contents << legacy_content
        legacy_connector.delete()
      end
      legacy_cms_node.delete()
    end

    @legacy_contents.each do |legacy_content|
      legacy_content.delete()
    end
  end
end