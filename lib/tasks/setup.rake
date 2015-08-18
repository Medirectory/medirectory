namespace :medirectory do

  desc 'Match providers to organizations using heuristics to populate a mapping table'
  task :match_providers_organizations => :environment do
    # NOTE: This approach is rather slow and not at all efficient, optimize if we do it more than occasionally
    ycount = ncount = 0
    start = Time.now
    Provider.find_each do |provider|
      if likely_organization = provider.likely_organization
        provider.organizations << likely_organization
        ycount += 1
      else
        ncount += 1
      end
      puts "Matches: #{ycount}  Non-matches: #{ncount}  (#{(Time.now - start).floor} seconds)" if (ycount + ncount) % 10000 == 0
    end
  end

  desc 'Load taxonomy mapping'
  task :load_taxonomy_map => :environment do
    taxonomies = File.read(Rails.root.join('resources', 'taxonomy_codes.csv')).encode('UTF-8', 'ISO8859-1')
    taxonomy_map = {
      'Code' => 'code',
      'Type' => 'taxonomy_type',
      'Classification' => 'classification',
      'Specialization' => 'specialization',
      'Definition' => 'definition',
      'Notes' => 'notes'
    }
    TaxonomyCode.copy_from StringIO.new(taxonomies), map: taxonomy_map
  end

  desc 'Load zip codes'
  task :load_zip_codes => :environment do
    zip_codes = File.read(Rails.root.join('resources', 'zip_lat_long.csv'))
    zip_codes_map = {
      'postal code' => 'postal_code',
      'latitude' => 'latitude',
      'longitude' => 'longitude'
    }
    ZipCode.copy_from StringIO.new(zip_codes), map: zip_codes_map, format: :tab
  end


  desc 'Match addresses to lat/long'
  task :match_addresses_to_lat_long => :environment do
    ZipCode.find_each do |zip_code|
      addresses = PracticeLocationAddress.where("postal_code LIKE ?", "#{zip_code.postal_code}%")
      addresses.update_all(latitude: zip_code.latitude, longitude: zip_code.longitude)
    end
  end


  desc 'Populate lat/long fields for faster search'
  task :populate_lat_long => :environment do
    count = Provider.update_all("practice_location_address_latitude = addresses.latitude, practice_location_address_longitude = addresses.longitude
                                                                                  FROM addresses
                                                                                  WHERE providers.npi = addresses.entity_id
                                                                                  AND addresses.entity_type = 'Provider'
                                                                                  AND addresses.type = 'PracticeLocationAddress'")
    puts "Updated geo search for #{count} Provider records"
    count = Organization.update_all("practice_location_address_latitude = addresses.latitude, practice_location_address_longitude = addresses.longitude
                                                                                  FROM addresses
                                                                                  WHERE organizations.npi = addresses.entity_id
                                                                                  AND addresses.entity_type = 'Organization'
                                                                                  AND addresses.type = 'PracticeLocationAddress'")
    puts "Updated geo search for #{count} Organization records"
  end

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

    count = Provider.update_all("searchable_location = CONCAT_WS(' ', COALESCE(addresses.city, ''),
                                                                      COALESCE(addresses.state, ''),
                                                                      SUBSTRING(COALESCE(addresses.postal_code, '') FROM 1 FOR 5))
                                                       FROM addresses
                                                       WHERE providers.npi = addresses.entity_id
                                                       AND addresses.type = 'PracticeLocationAddress'")
    puts "Updated location search for #{count} records"

    count = Provider.update_all("searchable_taxonomy = ARRAY_TO_STRING(ARRAY(SELECT CONCAT_WS(' ', COALESCE(taxonomy_codes.classification, ''),
                                                                                                   COALESCE(taxonomy_codes.specialization, ''))
                                                                             FROM taxonomy_licenses, taxonomy_codes
                                                                             WHERE providers.npi = taxonomy_licenses.entity_id
                                                                             AND taxonomy_licenses.entity_type = 'Provider'
                                                                             AND taxonomy_licenses.code = taxonomy_codes.code),
                                                                       ' ')")
    puts "Updated taxonomy search for #{count} records"

    count = Provider.update_all("searchable_organizations = ARRAY_TO_STRING(ARRAY(SELECT CONCAT_WS(' ', COALESCE(organizations.organization_name_legal_business_name, ''),
                                                                                                        COALESCE(organizations.other_organization_name, ''))
                                                                                  FROM organizations_providers, organizations
                                                                                  WHERE providers.npi = organizations_providers.provider_id
                                                                                  AND organizations_providers.organization_id = organizations.npi),
                                                                            ' ')")
    puts "Updated organization search for #{count} records"


    # Also create a more generic searchable field that includes all searchable content of interest (ie npi, name, city, zip, specialty)
    count = Provider.update_all("searchable_content = CONCAT_WS(' ', npi, searchable_name, searchable_location, searchable_taxonomy, searchable_organizations)")
    puts "Updated full search for #{count} records"


    # Concatenate business name into one searchable column, and authorized official name into another
    puts "Updating organization search columns..."
    count = Organization.update_all("searchable_name = CONCAT_WS(' ', COALESCE(organization_name_legal_business_name, ''),
                                                                      COALESCE(other_organization_name, '')),
                                     searchable_authorized_official = CONCAT_WS(' ', COALESCE(authorized_official_first_name, ''),
                                                                                     COALESCE(authorized_official_middle_name, ''),
                                                                                     COALESCE(authorized_official_last_name, ''))")
    puts "Updated name and official search for #{count} records"

    count = Organization.update_all("searchable_location = CONCAT_WS(' ', COALESCE(addresses.city, ''),
                                                                          COALESCE(addresses.state, ''),
                                                                          SUBSTRING(COALESCE(addresses.postal_code, '') FROM 1 FOR 5))
                                                           FROM addresses
                                                           WHERE organizations.npi = addresses.entity_id
                                                           AND addresses.type = 'PracticeLocationAddress'")
    puts "Updated location search for #{count} records"

    count = Organization.update_all("searchable_taxonomy = ARRAY_TO_STRING(ARRAY(SELECT CONCAT_WS(' ', COALESCE(taxonomy_codes.classification, ''),
                                                                                                       COALESCE(taxonomy_codes.specialization, ''))
                                                                                 FROM taxonomy_licenses, taxonomy_codes
                                                                                 WHERE organizations.npi = taxonomy_licenses.entity_id
                                                                                 AND taxonomy_licenses.entity_type = 'Organization'
                                                                                 AND taxonomy_licenses.code = taxonomy_codes.code),
                                                                           ' ')")
    puts "Updated taxonomy search for #{count} records"


    count = Organization.update_all("searchable_providers = ARRAY_TO_STRING(ARRAY(SELECT providers.searchable_name
                                                                                  FROM organizations_providers, providers
                                                                                  WHERE organizations.npi = organizations_providers.organization_id
                                                                                  AND organizations_providers.provider_id = providers.npi),
                                                                            ' ')")
    puts "Updated providers search for #{count} records"



    # Also create a more generic searchable field that includes all searchable content of interest (ie npi, name, city, zip, specialty)
    # Note: We don't include the authorized official name in this content
    count = Organization.update_all("searchable_content = CONCAT_WS(' ', npi, searchable_name, searchable_location, searchable_taxonomy)")
    puts "Updated full search for #{count} records"

  end

end
