defmodule OnlineOps.Repo.Migrations.CreateSpaceSetupStep do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE space_setup_state AS ENUM ('ACCOUNT','PROPERTY','VIEW', 'COMPLETE')")

    create table(:space_setup_steps, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :space_setup_state, null: false
      add :space_id, references(:spaces, on_delete: :nothing, type: :binary_id), null: false
      add :space_user_id, references(:space_users, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:space_setup_steps, [:id])
    create unique_index(:space_setup_steps, [:space_id, :state])
  end

  def down do
    drop table(:space_setup_steps)
    execute("DROP TYPE space_setup_state")
  end
end
