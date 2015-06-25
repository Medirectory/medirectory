class AddSearchableProvidersToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :searchable_providers, :string
    execute %{
      CREATE INDEX ON organizations USING GIN(TO_TSVECTOR('simple', searchable_providers));
    }
  end
  def down
    remove_column :organizations, :searchable_providers, :string
  end
end
