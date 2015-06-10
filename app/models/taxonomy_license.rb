class TaxonomyLicense < ActiveRecord::Base
  belongs_to :entity, polymorphic: true
  belongs_to :taxonomy_code, foreign_key: :code, primary_key: :code
end