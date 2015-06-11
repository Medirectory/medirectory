class TaxonomyCode < ActiveRecord::Base
  acts_as_copy_target
  has_many :taxonomy_licenses, foreign_key: :code, primary_key: :code
end
