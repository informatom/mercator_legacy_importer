class AddLegacyIds < ActiveRecord::Migration
  def self.up
    add_column :users, :legacy_id, :integer
    add_column :properties, :legacy_id, :integer
    add_column :countries, :legacy_id, :integer
    add_column :categories, :legacy_id, :integer
    add_column :webpages, :legacy_id, :integer
    add_column :products, :legacy_id, :integer
    add_column :page_templates, :legacy_id, :integer
    add_column :features, :legacy_id, :integer
    add_column :content_elements, :legacy_id, :integer
  end

  def self.down
    remove_column :users, :legacy_id
    remove_column :properties, :legacy_id
    remove_column :countries, :legacy_id
    remove_column :categories, :legacy_id
    remove_column :webpages, :legacy_id
    remove_column :products, :legacy_id
    remove_column :page_templates, :legacy_id
    remove_column :features, :legacy_id
    remove_column :content_elements, :legacy_id
  end
end
