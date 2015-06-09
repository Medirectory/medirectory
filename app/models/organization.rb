require 'textacular/searchable'

class Organization < ActiveRecord::Base
  # Use Textactular for searching, an alternate would be https://github.com/Casecommons/pg_search
  extend Searchable(:organization_name_legal_business_name, :other_organization_name, :authorized_official_last_name,
                    :authorized_official_first_name, :authorized_official_middle_name, :authorized_official_telephone_number)
  has_one :mailing_address, as: :entity
  has_one :practice_location_address, as: :entity
  has_many :other_provider_identifiers, as: :entity
  has_many :taxonomy_groups, as: :entity
  has_many :taxonomy_licenses, as: :entity
end
