defmodule OnlineOps.Repo.Migrations.CreateSpaceAuth do
  use Ecto.Migration

  def up do

    create table(:space_auth, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :property, :string
      add :view, :string
      add :refresh_token, :string
      add :space_id, references(:spaces, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:space_auth, [:id])
    create unique_index(:space_auth, [:space_id])
  end

  def down do
    drop table(:space_auth)
  end
end
