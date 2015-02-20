# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:page_templates RAILS_ENV=production'
  desc "Import page_templates from legacy webshop"
  task :page_templates => :environment do
    puts "\n\nPage Templates:"

    MercatorLegacyImporter::PageTemplate.all.each do |legacy_page_template|
      if page_template = PageTemplate.create(name: legacy_page_template.name,
                                             content: legacy_page_template.content,
                                             legacy_id: legacy_page_template.id)
        print "T"
      else
        puts "\nFAILURE: PageTemplate: " + page_template.errors.first.to_s
      end
    end
  end
end