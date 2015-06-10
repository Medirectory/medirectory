class TaxonomyCode < ActiveRecord::Base
  has_many :taxonomy_licenses, foreign_key: :code, primary_key: :code
end
