class AddSearchableOrganizationToProviders < ActiveRecord::Migration
  def up
    add_column :providers, :searchable_organization, :string
    execute %{
      CREATE INDEX ON providers USING GIN(TO_TSVECTOR('simple', searchable_organization));
    }
  end
  def down
    remove_column :providers, :searchable_organization
  end
end
