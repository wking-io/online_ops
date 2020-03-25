defmodule OnlineOps.Schemas.SpaceAuth do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schemas.Space

  @type t :: %__MODULE__{}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "space_auth" do
    field :property, :string
    field :view, :string
    field :refresh_token, :string

    belongs_to :space, Space

    timestamps()
  end

  @doc false
  def create_changeset(space_auth, attrs) do
    space_auth
    |> cast(attrs, [:property, :view, :refresh_token, :space_id])
    |> validate_required([:space_id])
  end
end
