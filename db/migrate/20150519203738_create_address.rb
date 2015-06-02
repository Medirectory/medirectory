class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :type  # mailing_address or practice_location_address
      t.string :first_line
      t.string :second_line
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country_code
      t.string :telephone_number
      t.string :fax_number
      t.references :entity, polymorphic: true, index: true
    end
  end
end
