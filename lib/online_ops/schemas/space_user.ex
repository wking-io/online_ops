defmodule OnlineOps.Schemas.SpaceUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schemas.User
  alias OnlineOps.Schemas.Space

  @type t :: %__MODULE__{}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "space_users" do
    field :role, :string

    belongs_to :space, Space
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def create_changeset(space_user, attrs) do
    space_user
    |> cast(attrs, [:role, :space_id, :user_id])
    |> validate_required([:role, :space_id, :user_id])
  end
end
