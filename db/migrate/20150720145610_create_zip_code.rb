class CreateZipCode < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :postal_code, index:true
      t.decimal :latitude, precision: 15, scale: 10, default: 0.0
      t.decimal :longitude, precision: 15, scale: 10, default: 0.0
    end
  end
end
