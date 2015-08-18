class CreateAddress < ActiveRecord::Migration
  def up
    create_table :addresses do |t|
      t.string :type  # mailing_address or practice_location_address
      t.string :first_line, index: true
      t.string :second_line, index: true
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country_code
      t.string :telephone_number, index: true
      t.string :fax_number, index: true
      t.references :entity, polymorphic: true, index: true
    end
    # We need this index type to support indexing for prefix searches
    ActiveRecord::Base.connection.execute("CREATE INDEX index_addresses_on_postal_code ON addresses (postal_code varchar_pattern_ops)")
  end
  def down
    drop_table :addresses
  end
end
