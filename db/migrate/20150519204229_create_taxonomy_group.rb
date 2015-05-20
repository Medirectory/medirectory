class CreateTaxonomyGroup < ActiveRecord::Migration
  def change
    create_table :taxonomy_groups do |t|
      t.string :taxonomy_group
      t.references :entity, polymorphic: true, index: true
    end
  end
end
