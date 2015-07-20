class AddGeoFieldsToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :latitude, :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :addresses, :longitude, :decimal, :precision => 15, :scale => 10, :default => 0.0
  end
end
