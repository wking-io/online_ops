defmodule OnlineOps.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schema.UserToken

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    has_one :token, UserToken

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
