class OrganizationsProviders < ActiveRecord::Migration
  def change
    create_table :organizations_providers, id: false do |t|
      t.integer :organization_id, index: true
      t.integer :provider_id, index: true
    end
  end
end
