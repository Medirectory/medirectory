class AddIndexesToAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :first_line
    add_index :addresses, :second_line
    add_index :addresses, :city
    add_index :addresses, :state
    add_index :addresses, :postal_code
    add_index :addresses, :telephone_number
    add_index :addresses, :fax_number
  end
end
