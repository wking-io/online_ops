defmodule OnlineOps.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_tokens" do
    field :value, :string
    field :user_id, :id

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
