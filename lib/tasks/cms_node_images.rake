namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:cms_node_images
  # in Produktivumgebungen: 'bundle exec rake legacy_import:cms_node_images RAILS_ENV=production'
  desc "Import cms node images from legacy webshop"
  task :cms_node_images => :environment do

    require 'net/http'
    puts "\n\nCMS Node Images:"

    @legacy_contents = []
    @legacy_attachables = []

    Net::HTTP.start("www.iv-shop.at") do |http|
      MercatorLegacyImporter::CmsNode.where(name: "images").each do |legacy_cms_node|
  #    MercatorLegacyImporter::CmsNode.all.each do |legacy_cms_node|

        webpage = Webpage.where(legacy_id: legacy_cms_node.parent_id).first

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

          content_element.name_de ||= content_element.name_en
          content_element.name_de ||= "Name fehlt (" + legacy_id.to_s + ")"

          legacy_attachable = MercatorLegacyImporter::Attachable.where(attachable_type: "Content", attachable_id: legacy_content.id).first
          unless legacy_attachable
            puts "\nFAILURE: Attachable not found " + legacy_content.id.to_s
            next
          end

          filename = "/system/datas/" + legacy_attachable.asset_id.to_s +
            "/original/" + legacy_content.name

          data = StringIO.new(http.get(filename).body)

          unless data
            puts "\nFAILURE: Image not found " + filename
            next
          end

          data.class.class_eval { attr_accessor :original_filename }
          data.original_filename = legacy_attachable.asset.data_file_name
          content_element.photo = data

          MercatorLegacyImporter::ContentItem.where(content_id: legacy_content.id).each do |legacy_content_item|
            content_element.content_de = legacy_content_item.value if @locale == "de"
            content_element.content_en = legacy_content_item.value if @locale == "en"
#            legacy_content_item.delete()
          end

          unless content_element.save
            # Trying to rescue duplicate names
            content_element.name_de = content_element.name_de + " - Duplikat (" + legacy_id.to_s + ")"
            unless content_element.save
              puts "\nFAILURE: ContentElement: " + content_element.errors.first.to_s
              next
            end
          end
          print "C"

          pcea = PageContentElementAssignment.find_or_initialize_by(used_as: @used_as,
                                                                    webpage_id: webpage.id,
                                                                    content_element_id: content_element.id)
          unless pcea.save
            puts "\nFAILURE: PageContentElementAssignment: " + pcea.errors.first.to_s
            next
          end
          print "A"

          @legacy_contents << legacy_content
          @legacy_attachables << legacy_attachable

 #         legacy_connector.delete()
        end
 #       legacy_cms_node.delete()
      end

      @legacy_contents.each do |legacy_content|
 #       legacy_content.delete()
      end
      @legacy_attachables.each do |legacy_attachable|
 #       legacy_attachable.delete()
      end
    end
  end
end