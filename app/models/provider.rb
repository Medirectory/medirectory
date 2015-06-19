require 'textacular/searchable'

class Provider < ActiveRecord::Base 
  # Use Textactular for searching, an alternate would be https://github.com/Casecommons/pg_search
  def self.searchable_language ; 'simple' ; end
  extend Searchable(:searchable_name, :searchable_location, :searchable_taxonomy, :searchable_content)
  has_one :mailing_address, as: :entity
  has_one :practice_location_address, as: :entity
  has_many :other_provider_identifiers, as: :entity
  has_many :taxonomy_groups, as: :entity
  has_many :taxonomy_licenses, as: :entity
  has_many :taxonomy_codes, through: :taxonomy_licenses
  has_and_belongs_to_many :organizations

  # Use heuristics to find the organization this provider is likely associated with
  def likely_organization
    match_keys = [[:telephone_number], [:fax_number], [:first_line, :second_line, :postal_code]]
    [mailing_address, practice_location_address].each do |address|
      match_keys.each do |mk|
        matcher = address.slice(*mk).reject { |k, v| v.blank? }
        if matcher.size > 0 && org_address = Address.where(matcher.merge(entity_type: 'Organization')).first
          return org_address.entity
        end
      end
    end
    return nil
  end

end
