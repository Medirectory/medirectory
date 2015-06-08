class ProviderSerializer < ActiveModel::Serializer
  attributes :npi
  has_one :mailing_address, as: :entity
  has_one :practice_location_address, as: :entity
  has_many :other_provider_identifiers, as: :entity
  has_many :taxonomy_groups, as: :entity
  has_many :taxonomy_licenses, as: :entity
end
