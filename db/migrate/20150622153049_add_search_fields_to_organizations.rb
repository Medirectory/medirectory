class AddSearchFieldsToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :searchable_location, :string
    add_column :organizations, :searchable_taxonomy, :string
    add_column :organizations, :searchable_content, :string
    execute %{
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_location));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_taxonomy));
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_content));
    }
  end
  def down
    remove_column :organizations, :searchable_location
    remove_column :organizations, :searchable_taxonomy
    remove_column :organizations, :searchable_content
  end
end
