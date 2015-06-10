class CreateOrganization < ActiveRecord::Migration
  def up
    create_table :organizations, id: false do |t|
      t.integer :npi, primary_key:true
      t.integer :entity_type_code
      t.string :ein
      t.integer :replacement_npi
      t.string :organization_name_legal_business_name
      t.string :other_organization_name
      t.string :other_organization_name_type_code
      t.date :enumeration_date
      t.date :last_update_date
      t.string :npi_deactivation_code
      t.date :npi_deactivation_date
      t.date :npi_reactivation_date
      t.string :authorized_official_last_name
      t.string :authorized_official_first_name
      t.string :authorized_official_middle_name
      t.string :authorized_official_name_prefix
      t.string :authorized_official_name_suffix
      t.string :authorized_official_credential
      t.string :authorized_official_titleor_position
      t.string :authorized_official_telephone_number
      t.string :is_organization_subpart
      t.string :parent_organization_lbn
      t.string :parent_organization_tin
      t.string :searchable_name
      t.string :searchable_authorized_official
    end
    execute %{
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_name));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_authorized_official));
    }
  end
  def down
    drop_table :organizations
  end
end
