class CreateTaxonomyCodes < ActiveRecord::Migration
  def change
    create_table :taxonomy_codes do |t|
      t.string :code, index: true
      t.string :taxonomy_type
      t.string :classification
      t.string :specialization
      t.string :definition
      t.string :notes
    end
  end
end
