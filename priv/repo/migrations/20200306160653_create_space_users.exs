defmodule OnlineOps.Repo.Migrations.CreateSpaceUsers do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE space_user_role AS ENUM ('OWNER','ADMIN','MEMBER','VIEWER')")

    create table(:space_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :space_user_role, null: false, default: "MEMBER"
      add :space_id, references(:spaces, on_delete: :nothing, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:space_users, [:space_id, :user_id])
  end

  def down do
    drop table(:space_users)
    execute("DROP TYPE space_user_role")
  end
end
