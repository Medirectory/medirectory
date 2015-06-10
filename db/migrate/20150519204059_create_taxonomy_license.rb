class CreateTaxonomyLicense < ActiveRecord::Migration
  def change
    create_table :taxonomy_licenses do |t|
      t.string :code
      t.string :license_number
      t.string :license_number_state_code
      t.string :primary_taxonomy_switch
      t.references :entity, polymorphic: true, index: true
    end
  end
end
