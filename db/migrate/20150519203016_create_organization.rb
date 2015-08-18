class CreateOrganization < ActiveRecord::Migration
  def up
    create_table :organizations do |t|
      t.string :ein
      t.string :organization_name_legal_business_name
      t.string :other_organization_name
      t.string :other_organization_name_type_code
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
      t.string :searchable_location
      t.string :searchable_taxonomy
      t.string :searchable_providers
      t.string :searchable_content
    end
    execute %{
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_name));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_authorized_official));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_location));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_taxonomy));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_providers));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_content));
    }
  end
  def down
    drop_table :organizations
  end
end
