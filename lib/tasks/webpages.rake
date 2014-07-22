# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:webpages
  # in Produktivumgebungen: 'bundle exec rake legacy_import:webpages RAILS_ENV=production'
  desc "Import webpages from legacy webshop"
  task :webpages => :environment do
    puts "\n\nWebpages:"

    MercatorLegacyImporter::CmsNode.where(typus: "Page").each do |legacy_cms_node|
      legacy_cms_node_de = legacy_cms_node.cms_node_translations.german.first
      legacy_cms_node_en = legacy_cms_node.cms_node_translations.english.first

      page_template = PageTemplate.where(legacy_id: legacy_cms_node.page_template_id).first
      parent = Webpage.where(legacy_id: legacy_cms_node.parent_id).first

      status = legacy_cms_node.state
      status = "published_but_hidden" if legacy_cms_node.hide_from_menu? && legacy_cms_node.state == "published"
      webpage = Webpage.new(title_de: ( legacy_cms_node_de.title.present? ? legacy_cms_node_de.title : legacy_cms_node.name ),
                      title_en: legacy_cms_node_en.title,
                      url: legacy_cms_node.url,
                      position: legacy_cms_node.position,
                      parent_id: ( parent.id if parent ),
                      page_template_id: page_template.id,
                      legacy_id: legacy_cms_node.id)
      webpage.state = status
      if webpage.save
        print "W"
      else
        puts "\nFAILURE: Webpage: " + webpage.errors.first.to_s
      end
    end
  end
end