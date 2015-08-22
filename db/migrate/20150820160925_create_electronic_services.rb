class CreateElectronicServices < ActiveRecord::Migration
  def change
    create_table :electronic_services do |t|
      t.string :address
      t.string :integration_profile
      t.string :content_profile
      t.string :digital_certificate
      t.references :provider, index: true, null: true
      t.references :organization, index: true, null: true
      t.timestamps null: false
    end
  end
end
