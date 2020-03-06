defmodule OnlineOps.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset


  alias OnlineOps.Schemas.SpaceUser

  @type t :: %__MODULE__{}

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    has_many :space_users, SpaceUser

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, email_format())
    |> unique_constraint(:email, name: :users_email_index, message: "already taken")
  end

  @doc false
  def get_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, email_format())
  end

  defp email_format do
    ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
  end
end
