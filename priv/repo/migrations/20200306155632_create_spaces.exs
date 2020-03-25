defmodule OnlineOps.Repo.Migrations.CreateSpaces do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE space_state AS ENUM ('SETUP','ACTIVE','ARCHIVED')")

    create table(:spaces, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :state, :space_state, null: false, default: "SETUP"
      add :name, :string

      timestamps()
    end

    create index(:spaces, [:id])
  end

  def down do
    drop table(:spaces)
    execute("DROP TYPE space_state")
  end
end
