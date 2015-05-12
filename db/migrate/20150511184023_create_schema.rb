class CreateSchema < ActiveRecord::Migration
  def change
    create_table :provider do |t|
      t.integer :npi, :primary_key, :index, :limit => 8  # sets it up as a long, needs to handle all 10 digit numbers
      t.integer :entity_type_code
      t.integer :replacement_npi, :limit => 8
      t.string :ein
      t.string :organization_name_legal_business_name
      t.string :last_name_legal_name
      t.string :first_name
      t.string :middle_name
      t.string :name_prefix
      t.string :name_suffix
      t.string :credential
      t.string :other_organization_name
      t.string :other_organization_name_type_code
      t.string :other_last_name
      t.string :other_first_name
      t.string :other_middle_name
      t.string :other_name_prefix
      t.string :other_name_suffix
      t.string :other_credential
      t.integer :other_last_name_type_code
      t.date :enumeration_date
      t.date :last_update_date
      t.string :npi_deactivation_reason_code
      t.date :npi_deactivation_date
      t.date :npi_reactivation_date
      t.string :gender_code
      t.string :authorized_official_last_name
      t.string :authorized_official_first_name
      t.string :authorized_official_middle_name
      t.string :authorized_official_name_prefix
      t.string :authorized_official_name_suffix
      t.string :authorized_official_credential
      t.string :authorized_official_titleor_position
      t.string :authorized_official_telephone_number
      t.string :is_sole_proprietor
      t.string :is_organization_subpart
      t.string :parent_organization_lbn
      t.string :parent_organization_tin
    end

    create_table :taxonomy_license do |t|
      t.string :taxonomy_code
      t.string :license_number
      t.string :license_number_state_code
      t.string :primary_taxonomy_switch
      t.integer :npi_fk
    end

    create_table :taxonomy_group do |t|
      t.string :taxonomy_group
      t.integer :npi_fk
    end

    create_table :other_provider_identifier do |t|
      t.string :identifier
      t.string :identifier_type_code
      t.string :identifier_state
      t.string :identifier_issuer
      t.integer :npi_fk
    end

    create_table :address do |t|
      t.strign :type  # mailing_address or practice_location_address
      t.string :first_line
      t.string :second_line
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country_code
      t.string :telephone_number
      t.string :fax_number
      t.integer :npi_fk
    end

    # foreign keys
    add_foreign_key :taxonomy_license, :provider, column: :npi_fk
    add_foreign_key :taxonomy_group, :provider, column: :npi_fk
    add_foreign_key :other_provider, :provider, column: :npi_fk
    add_foreign_key :address, :provider, column: :npi_fk
  end
end