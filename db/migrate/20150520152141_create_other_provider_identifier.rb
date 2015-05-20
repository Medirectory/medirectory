class CreateOtherProviderIdentifier < ActiveRecord::Migration
  def change
    create_table :other_provider_identifiers do |t|
      t.string :identifier
      t.string :identifier_type_code
      t.string :identifier_state
      t.string :identifier_issuer
      t.references :entity, polymorphic: true, index: true
    end
  end
end
