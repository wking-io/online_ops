defmodule OnlineOps.Schemas.Space do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schema.SpaceUser
  alias OnlineOps.Schema.GaData

  @type t :: %__MODULE__{}

  schema "spaces" do
    field :state, :string
    field :refresh_token, :string
    field :name, :string

    has_many :space_users, SpaceUser
    has_many :ga_data, GaData

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:state, :refresh_token, :name])
    |> validate_required([:state, :refresh_token, :name])
  end
end
