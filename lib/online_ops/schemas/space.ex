defmodule OnlineOps.Schemas.Space do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schemas.SpaceUser
  alias OnlineOps.Schemas.GaData

  @type t :: %__MODULE__{}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "spaces" do
    field :state, :string
    field :property, :string
    field :view, :string
    field :refresh_token, :string
    field :name, :string

    has_many :space_users, SpaceUser
    has_many :ga_data, GaData

    timestamps()
  end

  @doc false
  def create_changeset(space, attrs) do
    space
    |> cast(attrs, [:state, :property, :view, :refresh_token, :name])
    |> validate_required([:state])
  end

  def update_changeset(space, attrs) do
    space
    |> cast(attrs, [:state, :property, :view, :refresh_token, :name])
  end
end
