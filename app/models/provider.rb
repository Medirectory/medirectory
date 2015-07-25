require 'textacular/searchable'

class Provider < ActiveRecord::Base 

  # Use Textactular for searching, an alternate would be https://github.com/Casecommons/pg_search
  def self.searchable_language ; 'simple' ; end
  extend Searchable(:searchable_name, :searchable_location, :searchable_taxonomy, :searchable_content)

  # Offer a search interface that allows for more complex query specification (ie AND, OR, *, etc) that
  # converts it to a Postgres full text query
  # NOTE: This will certainly need more work; a better approach may be to just expose the Postgres query
  # language at the API level and provide more richness at the interface level
  def self.complex_search(terms)
    # Massage input to appropriate form
    terms.keys.each do |k|
      # First strip out most special search characters, we don't want them being used directly
      terms[k].gsub!(/[^a-zA-Z0-9*]+/, ' ')
      # Convert appropriate usage of * to :*, and remove all innapropriate usage of *
      terms[k] = terms[k].gsub(/([^a-zA-Z0-9])\*/, '\1').gsub(/\*([a-zA-Z0-9])/, '\1').gsub(/\*/, ':*')
      # Now convert AND, OR, and NOT to appropriate characters
      terms[k] = terms[k].gsub(/\s+AND\s+/, '&').gsub(/\s+OR\s+/, '|').gsub(/NOT\s+/, '!')
    end
    self.advanced_search(terms)
  end

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
  
  scope :within_radius, lambda {|latitude, longitude, metres| where("earth_box(ll_to_earth(?, ?), ?) @> ll_to_earth(latitude, longitude)", latitude, longitude, metres) }

end
