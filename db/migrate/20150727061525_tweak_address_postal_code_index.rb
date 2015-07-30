class TweakAddressPostalCodeIndex < ActiveRecord::Migration
  def up
    remove_index :addresses, :postal_code
    # We need this index type to support indexing for prefix searches
    ActiveRecord::Base.connection.execute("CREATE INDEX index_addresses_on_postal_code ON addresses (postal_code varchar_pattern_ops)")
  end
  def down
    remove_index :addresses, :postal_code
    add_index :addresses, :postal_code
  end
end
