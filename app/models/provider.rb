require 'textacular/searchable'

class Provider < ActiveRecord::Base 
  # Use Textactular for searching, an alternate would be https://github.com/Casecommons/pg_search
  extend Searchable(:last_name_legal_name, :first_name, :middle_name, :other_last_name, :other_first_name, :other_middle_name)
  has_one :mailing_address, as: :entity
  has_one :practice_location_address, as: :entity
  has_many :other_provider_identifiers, as: :entity
  has_many :taxonomy_groups, as: :entity
  has_many :taxonomy_licenses, as: :entity
end
