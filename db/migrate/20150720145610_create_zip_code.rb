class CreateZipCode < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :country_code
      t.string :postal_code, index:true
      t.string :place_name
      t.string :state
      t.string :state_code
      t.string :city
      t.string :city_code
      t.string :community
      t.string :community_code
      t.decimal :latitude, precision: 15, scale: 10, default: 0.0
      t.decimal :longitude, precision: 15, scale: 10, default: 0.0
      t.integer :accuracy
    end
  end
end
