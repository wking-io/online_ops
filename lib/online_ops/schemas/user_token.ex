defmodule OnlineOps.Schema.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schema.User

  schema "user_tokens" do
    belongs_to :user, User

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
