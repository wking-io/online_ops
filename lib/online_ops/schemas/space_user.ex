defmodule OnlineOps.Schemas.SpaceUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schemas.User
  alias OnlineOps.Schemas.Space

  @type t :: %__MODULE__{}

  schema "space_users" do
    field :role, :string

    belongs_to :space, Space
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:role, :space_id, :user_id])
    |> validate_required([:role, :space_id, :user_id])
  end
end
