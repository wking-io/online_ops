defmodule OnlineOps.Schemas.Space do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schemas.SpaceUser
  alias OnlineOps.Schemas.SpaceAuth
  alias OnlineOps.Schemas.GaData

  @type t :: %__MODULE__{}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "spaces" do
    field :state, :string
    field :name, :string

    has_many :space_users, SpaceUser
    has_many :ga_data, GaData
    has_one :space_auth, SpaceAuth

    timestamps()
  end

  @doc false
  def create_changeset(space, attrs) do
    space
    |> cast(attrs, [:state, :name])
    |> validate_required([:state])
  end

  def update_changeset(space, attrs) do
    space
    |> cast(attrs, [:state, :name])
  end
end
