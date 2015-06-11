class CreateProvider < ActiveRecord::Migration
  def up
    create_table :providers, id: false do |t|
      t.integer :npi, primary_key:true
      t.integer :entity_type_code
      t.integer :replacement_npi
      t.string :last_name_legal_name
      t.string :first_name
      t.string :middle_name
      t.string :name_prefix
      t.string :name_suffix
      t.string :credential
      t.string :other_last_name
      t.string :other_first_name
      t.string :other_middle_name
      t.string :other_name_prefix
      t.string :other_name_suffix
      t.string :other_credential
      t.integer :other_last_name_type_code
      t.date :enumeration_date
      t.date :last_update_date
      t.string :npi_deactivation_reason_code
      t.date :npi_deactivation_date
      t.date :npi_reactivation_date
      t.string :gender_code
      t.string :is_sole_proprietor
      t.string :searchable_name
      t.string :searchable_location
      t.string :searchable_taxonomy
      t.string :searchable_content
    end
    execute %{
      CREATE INDEX ON providers USING GIN(TO_TSVECTOR('simple', searchable_name));
      CREATE INDEX ON providers USING GIN(TO_TSVECTOR('simple', searchable_location));
      CREATE INDEX ON providers USING GIN(TO_TSVECTOR('simple', searchable_taxonomy));
      CREATE INDEX ON providers USING GIN(TO_TSVECTOR('simple', searchable_content));
    }
  end
  def down
    drop_table :providers
  end
end
