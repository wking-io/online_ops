defmodule OnlineOps.Schemas.Space do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schemas.SpaceUser
  alias OnlineOps.Schemas.GaData

  @type t :: %__MODULE__{}

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
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:state, :property, :view, :refresh_token, :name])
    |> validate_required([:state, :property, :view, :refresh_token, :name])
  end
end
