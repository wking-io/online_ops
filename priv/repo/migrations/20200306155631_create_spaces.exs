defmodule OnlineOps.Repo.Migrations.CreateSpaces do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE space_state AS ENUM ('ACTIVE','ARCHIVED')")

    create table(:spaces) do
      add :state, :space_state, null: false, default: "ACTIVE"
      add :property, :string, null: false
      add :view, :string, null: false
      add :refresh_token, :string, null: false
      add :name, :string, null: false

      timestamps()
    end
  end

  def down do
    drop table(:spaces)
    execute("DROP TYPE space_state")
  end
end
