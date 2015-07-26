class AddGeoFieldsToAddresses < ActiveRecord::Migration
  def up
    add_column :addresses, :latitude, :decimal, precision: 15, scale: 10
    add_column :addresses, :longitude, :decimal, precision: 15, scale: 10
  end
  def down
    remove_column :addresses, :latitude
    remove_column :addresses, :longitude
  end
end
