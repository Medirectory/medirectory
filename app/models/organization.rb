require 'textacular/searchable'

class Organization < ActiveRecord::Base
  # Use Textactular for searching, an alternate would be https://github.com/Casecommons/pg_search
  def self.searchable_language ; 'simple' ; end
  extend Searchable(:searchable_name, :searchable_authorized_official)
  has_one :mailing_address, as: :entity
  has_one :practice_location_address, as: :entity
  has_many :other_provider_identifiers, as: :entity
  has_many :taxonomy_groups, as: :entity
  has_many :taxonomy_licenses, as: :entity
  has_many :taxonomy_codes, through: :taxonomy_licenses
  has_and_belongs_to_many :providers

  # Use heuristics to find providers that are likely to be part of this organization
  def likely_providers
    providers = []
    match_keys = [[:telephone_number], [:fax_number], [:first_line, :second_line, :postal_code]]
    [mailing_address, practice_location_address].each do |address|
      match_keys.each do |mk|
        matcher = address.slice(*mk).reject { |k, v| v.blank? }
        if matcher.size > 0
          providers |= Address.where(matcher.merge(entity_type: 'Provider')).map(&:entity)
        end
      end
    end
    return providers
  end
  
  scope :within_radius, lambda {|latitude, longitude, metres| where("earth_box(ll_to_earth(?, ?), ?) @> ll_to_earth(practice_location_address_latitude, practice_location_address_longitude)", latitude, longitude, metres) }
  
end
