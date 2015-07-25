class AddLatitudeLongitudeToEntities < ActiveRecord::Migration
  def up
    add_column :providers, :practice_location_address_latitude, :decimal, precision: 15, scale: 10, default: 0.0
    add_column :providers, :practice_location_address_longitude, :decimal, precision: 15, scale: 10, default: 0.0  
    execute %{
      CREATE INDEX on providers USING gist(ll_to_earth(practice_location_address_latitude, practice_location_address_longitude));
    }
    add_column :organizations, :practice_location_address_latitude, :decimal, precision: 15, scale: 10, default: 0.0
    add_column :organizations, :practice_location_address_longitude, :decimal, precision: 15, scale: 10, default: 0.0  
    execute %{
      CREATE INDEX on organizations USING gist(ll_to_earth(practice_location_address_latitude, practice_location_address_longitude));
    }
  end
  def down
    remove_column :providers, :practice_location_address_latitude
    remove_column :providers, :practice_location_address_longitude
    remove_column :organizations, :practice_location_address_latitude
    remove_column :organizations, :practice_location_address_longitude
  end
end
