namespace :medirectory do

  desc 'Populate search-specific provider and organization columns'
  task :populate_search => :environment do
    # Concatenate all name fields and alternate name fields, but don't include the alternate name if it's the same as the primary name
    # ie Alice Smith / Alice Jones should be stored as Alice Smith Jones
    puts "Updating provider search columns..."
    count = Provider.update_all("searchable_name = CONCAT_WS(' ', COALESCE(first_name, ''),
                                                                  COALESCE(middle_name, ''),
                                                                  COALESCE(last_name_legal_name, ''),
                                                                  COALESCE(NULLIF(other_first_name, first_name), ''),
                                                                  COALESCE(NULLIF(other_middle_name, middle_name), ''),
                                                                  COALESCE(NULLIF(other_last_name, last_name_legal_name), ''))")
    puts "Updated name search for #{count} records"

    # Also create a more generic searchable field that includes all searchable content of interest (ie npi, name, city, zip, specialty)
    # FIXME: Still need to add specialty
    count = Provider.update_all("searchable_content = CONCAT_WS(' ', providers.npi, providers.searchable_name,
                                                                     COALESCE(addresses.city, ''),
                                                                     SUBSTRING(COALESCE(addresses.postal_code, '') FROM 1 FOR 5))
                                                      FROM addresses
                                                      WHERE addresses.type = 'PracticeLocationAddress'
                                                      AND addresses.entity_id = providers.npi")
    puts "Updated full search for #{count} records"


    # Concatenate business name into one searchable column, and authorized official name into another
    puts "Updating organization search columns..."
    count = Organization.update_all("searchable_name = CONCAT_WS(' ', COALESCE(organization_name_legal_business_name, ''),
                                                                      COALESCE(other_organization_name, '')),
                                     searchable_authorized_official = CONCAT_WS(' ', COALESCE(authorized_official_first_name, ''),
                                                                                     COALESCE(authorized_official_middle_name, ''),
                                                                                     COALESCE(authorized_official_last_name, ''))")
    puts "Updated #{count} records"

  end

end  