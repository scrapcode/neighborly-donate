class ChangeNeighbourhoodToNeighborhoodOnContributionReportsForProjectOwnersView < ActiveRecord::Migration
  def up
    drop_view :contribution_reports_for_project_owners

    execute <<-SQL
      CREATE OR REPLACE VIEW contribution_reports_for_project_owners AS
      SELECT
        b.project_id,
        coalesce(r.id, 0) as reward_id,
        r.description as reward_description,
        TO_CHAR(r.minimum_value, 'FM999999999') as reward_minimum_value,
        TO_CHAR(b.created_at, 'HH12:MIam DD Mon YY') as created_at,
        TO_CHAR(b.confirmed_at, 'HH12:MIam DD Mon YY') as confirmed_at,
        TO_CHAR(b.value, 'FM999999999') as back_value,
        TO_CHAR((b.value* (SELECT value::numeric FROM configurations WHERE name = 'catarse_fee') ), 'FM999999999.00') as service_fee,
        u.email as user_email,
        u.name as user_name,
        b.payer_email as payer_email,
        b.payment_method,
        coalesce(b.address_street, u.address_street) as street,
        coalesce(b.address_complement, u.address_complement) as complement,
        coalesce(b.address_number, u.address_number) as address_number,
        coalesce(b.address_neighborhood, u.address_neighborhood) as neighborhood,
        coalesce(b.address_city, u.address_city) as city,
        coalesce(b.address_state, u.address_state) as state,
        coalesce(b.address_zip_code, u.address_zip_code) as zip_code,
        b.anonymous,
        b.short_note
      FROM
        contributions b
      JOIN users u ON u.id = b.user_id
      LEFT JOIN rewards r ON r.id = b.reward_id
      WHERE
        b.state = 'confirmed'
      ORDER By b.confirmed_at, b.id;
    SQL
  end

  def down
    drop_view :contribution_reports_for_project_owners

    execute <<-SQL
      CREATE OR REPLACE VIEW contribution_reports_for_project_owners AS
      SELECT
        b.project_id,
        coalesce(r.id, 0) as reward_id,
        r.description as reward_description,
        TO_CHAR(r.minimum_value, 'FM999999999') as reward_minimum_value,
        TO_CHAR(b.created_at, 'HH12:MIam DD Mon YY') as created_at,
        TO_CHAR(b.confirmed_at, 'HH12:MIam DD Mon YY') as confirmed_at,
        TO_CHAR(b.value, 'FM999999999') as back_value,
        TO_CHAR((b.value* (SELECT value::numeric FROM configurations WHERE name = 'catarse_fee') ), 'FM999999999.00') as service_fee,
        u.email as user_email,
        u.name as user_name,
        b.payer_email as payer_email,
        b.payment_method,
        coalesce(b.address_street, u.address_street) as street,
        coalesce(b.address_complement, u.address_complement) as complement,
        coalesce(b.address_number, u.address_number) as address_number,
        coalesce(b.address_neighborhood, u.address_neighborhood) as neighbourhood,
        coalesce(b.address_city, u.address_city) as city,
        coalesce(b.address_state, u.address_state) as state,
        coalesce(b.address_zip_code, u.address_zip_code) as zip_code,
        b.anonymous,
        b.short_note
      FROM
        contributions b
      JOIN users u ON u.id = b.user_id
      LEFT JOIN rewards r ON r.id = b.reward_id
      WHERE
        b.state = 'confirmed'
      ORDER By b.confirmed_at, b.id;
    SQL
  end
end
