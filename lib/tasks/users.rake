def import_users
  puts "\nUsers:"

  MercatorLegacyImporter::User.all.each do |legacy_user|
    user = User.find_or_initialize_by_name(legacy_user.name)
    if user.update_attributes(email_address: legacy_user.email,
                              legacy_id: legacy_user.id)
      print "U"
    else
      puts "\nFAILURE: User: " + user.errors.first.to_s
    end
  end
end

namespace :users do
  # starten als: 'bundle exec rake users:update_mesonic_data
  # in Produktivumgebungen: 'bundle exec rake users:update_mesonic_data RAILS_ENV=production'
  desc "Import from legacy webshop"
  task :update_mesonic_data => :environment do
    ::JobLogger.info("=" * 50)
    ::JobLogger.info("Started Job: users:update_mesonic_data")

    User.all.each do |user|
      if user.legacy_id
        @legacy_user = MercatorLegacyImporter::User.find(user.legacy_id)
        if user.update(erp_contact_nr: @legacy_user.mesonic_account_mesoprim,
                       erp_account_nr: @legacy_user.account_number_mesoprim)
          ::JobLogger.error("User " + user.id + " (" + user.name + ") updated.")
        else
          ::JobLogger.error("User " + user.id + " (" + user.name + ") update failed.")
        end
      end
    end

    ::JobLogger.info("Finished Job: users:update_mesonic_data")
    ::JobLogger.info("=" * 50)
  end
end