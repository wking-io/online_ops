defmodule OnlineOps.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_tokens, [:user_id])
  end
end
