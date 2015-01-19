# encoding: utf-8

namespace :legacy_import do
  # starten als: 'bundle exec rake legacy_import:categories
  # in Produktivumgebungen: 'bundle exec rake legacy_import:categories RAILS_ENV=production'
  desc "Import categories from legacy webshop"
  task :categories => :environment do

    puts "\n\nCategories:"
    Category.all.each do |category|
      category.delete
    end
    print "Categories deleted."

    MercatorLegacyImporter::Category.all.each do |legacy_category|
      legacy_category_de = legacy_category.category_translations.german.first
      legacy_category_en = legacy_category.category_translations.english.first

      category = Category.create(name_de: legacy_category_de.title && legacy_category.name)
      parent = Category.find_by_legacy_id(legacy_category.parent_id)

      name_en = legacy_category_en.title.present? ? legacy_category_en.title : "missing_name"

      if category.update_attributes(name_en: name_en,
                                   description_de: legacy_category_de.short_description,
                                   description_en: legacy_category_en.short_description,
                                   long_description_de: legacy_category_de.long_description,
                                   long_description_en:  legacy_category_en.long_description,
                                   position:  legacy_category.position,
                                   parent: ( parent if parent ) ,
                                   legacy_id: legacy_category.id)
        category.state = "active" if legacy_category.active == true
        if category.save
          print "C"
        else
          puts "\nFAILURE: Category " + category.errors.first.to_s
        end
      else
        puts "\nFAILURE: Category " + category.errors.first.to_s
      end
    end
  end

  # starten als: 'bundle exec rake legacy_import:only_active_categories_part1 RAILS_ENV=production'
  desc "Import only active categories from legacy webshop"
  task :only_active_categories_part1 => :environment do
    puts "Categories:"
    Category.all.each do |category|
      category.delete
    end
    puts "Categories deleted."

    Category.mercator()
    Category.auto()

    Category.discounts()
    Category.novelties()
    Category.topseller()
    Category.orphans()
    puts "Created default categories"

    MercatorLegacyImporter::Category.all.each do |legacy_category|
      next unless legacy_category.active
      legacy_category_de = legacy_category.category_translations.german.first
      legacy_category_en = legacy_category.category_translations.english.first

      category = Category.create(name_de: legacy_category_de.title && legacy_category.name)

      name_en = legacy_category_en.title.present? ? legacy_category_en.title : "missing_name"
      category.update_attributes(usage: :standard,
                                 squeel_condition: legacy_category.category_conditions,
                                 name_en: name_en,
                                 description_de: legacy_category_de.short_description,
                                 description_en: legacy_category_en.short_description,
                                 long_description_de: legacy_category_de.long_description,
                                 long_description_en:  legacy_category_en.long_description,
                                 position:  legacy_category.position,
                                 legacy_id: legacy_category.id,
                                 erp_identifier: legacy_category.category_product_group,
                                 filtermin: 1,
                                 filtermax: 1,
                                 parent_id: nil) or
      (( puts "\nFAILURE: Category " + category.errors.first.to_s ))

      category.state = "active" if legacy_category.active == true
      category.save or
      (( puts "\nFAILURE: Category " + category.errors.first.to_s ))
    end

    Category.all.each do |category|
      next unless category.legacy_id
      legacy_parent_id = MercatorLegacyImporter::Category.find(category.legacy_id).parent_id
      if legacy_parent_id.present? && parent = Category.find_by(legacy_id: legacy_parent_id)
        category.update(parent_id: parent.id) or
        (( puts "\nFAILURE: Category parent is missing: " + category.errors.first.to_s ))
      end
    end
  end

  # starten als: 'bundle exec rake legacy_import:only_active_categories_part2 RAILS_ENV=production'
  desc "Import only active categories from legacy webshop"
  task :only_active_categories_part2 => :environment do
    MercatorMesonic::Webartikel.update_categorizations()
    Category.deprecate()
    Category.deprecated.delete_all
    Category.reindexing_and_filter_updates()
  end

  # starten als: 'bundle exec rake legacy_import:fix_squeel RAILS_ENV=production'
  desc "SQL-SQUEEL Translations"
  task :fix_squeel => :environment do
    category = Category.find_by(squeel_condition: "( WEBARTIKEL.PreisdatumVON <= NOW() ) AND ( WEBARTIKEL.PreisdatumBIS >= NOW() )")
    category.update(squeel_condition: "(preisdatumVON <= Time.now) & (preisdatumBIS >= Time.now)")

    category = Category.find_by(squeel_condition: "( WEBARTIKEL.Kennzeichen = 'X' )")
    category.update(squeel_condition: "kennzeichen == 'X'")

    category = Category.find_by(squeel_condition: "( WEBARTIKEL.Artikeluntergruppe <= '00060-00090-00090-00000-00000' ) AND ( WEBARTIKEL.Artikeluntergruppe >= '00060-00090-00000-00000-00000' )")
    category.update(squeel_condition: "(artikeluntergruppe <= '00060-00090-00090-00000-00000') & (artikeluntergruppe >= '00060-00090-00000-00000-00000')")

    category = Category.find_by(squeel_condition: "( WEBARTIKEL.Artikeluntergruppe <= '00045-00020-00013-00000-00000' ) AND ( WEBARTIKEL.Artikeluntergruppe >= '00045-00020-00010-00000-00000' )")
    category.update(squeel_condition: "(artikeluntergruppe <= '00045-00020-00013-00000-00000') & (artikeluntergruppe >= '00045-00020-00010-00000-00000')")
  end
end