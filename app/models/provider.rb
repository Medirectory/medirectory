require 'textacular/searchable'

class Provider < ActiveRecord::Base 
  # Use Textactular for searching, an alternate would be https://github.com/Casecommons/pg_search
  def self.searchable_language ; 'simple' ; end
  extend Searchable(:searchable_name, :searchable_content)
  has_one :mailing_address, as: :entity
  has_one :practice_location_address, as: :entity
  has_many :other_provider_identifiers, as: :entity
  has_many :taxonomy_groups, as: :entity
  has_many :taxonomy_licenses, as: :entity
end
