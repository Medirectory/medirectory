class TaxonomyLicenseSerializer < ActiveModel::Serializer
  delegate :attributes, to: :object
  has_one :taxonomy_code,  foreign_key: :code, primary_key: :code
end