defmodule OnlineOps.Repo.Migrations.CreateGaData do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE ga_data_group AS ENUM ('DEVICE','SOURCE')")
    execute("CREATE TYPE ga_data_type AS ENUM ('MOBILE','TABLET','DESKTOP','ORGANIC','DIRECT','EMAIL','REFERRAL','OTHER','SOCIAL','PAID')")

    create table(:ga_data, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :group, :ga_data_group, null: false
      add :type, :ga_data_type, null: false
      add :date, :naive_datetime, null: false
      add :space_id, references(:spaces, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:ga_data, [:id])
    create unique_index(:ga_data, [:space_id])
  end

  def down do
    drop table(:space_users)
    execute("DROP TYPE ga_data_group")
    execute("DROP TYPE ga_data_type")
  end
end
