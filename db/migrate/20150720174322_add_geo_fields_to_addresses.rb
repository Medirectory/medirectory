class AddGeoFieldsToAddresses < ActiveRecord::Migration
  def up
    add_column :addresses, :latitude, :decimal, precision: 15, scale: 10, default: 0.0
    add_column :addresses, :longitude, :decimal, precision: 15, scale: 10, default: 0.0
    execute %{
      CREATE INDEX on addresses USING gist(ll_to_earth(latitude, longitude));
    }
  end
  def down
    remove_column :addresses, :latitude
    remove_column :addresses, :longitude
  end
end
