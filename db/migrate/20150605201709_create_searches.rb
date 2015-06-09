class CreateSearches < ActiveRecord::Migration
  def up
    execute %{
      CREATE VIEW searches AS

        SELECT
          npi AS npi,
          npi AS entity_id,
          'Provider' AS entity_type,
          last_name_legal_name, first_name, middle_name, other_last_name, other_first_name, other_middle_name
          FROM providers

        UNION SELECT
          npi AS npi,
          npi AS entity_id,
          'Organization' AS entity_type,
          organization_name_legal_business_name, other_organization_name, authorized_official_last_name,
          authorized_official_first_name, authorized_official_middle_name, authorized_official_telephone_number
          FROM organizations;
    }
  end

  def down
    execute "DROP VIEW searchables;"
  end
end
