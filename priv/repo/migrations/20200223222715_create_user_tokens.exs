defmodule OnlineOps.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create unique_index(:user_tokens, [:user_id])
  end
end
