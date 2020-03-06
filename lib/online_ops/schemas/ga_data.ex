defmodule OnlineOps.Schemas.GaData do
  use Ecto.Schema
  import Ecto.Changeset

  alias OnlineOps.Schema.Space

  @type t :: %__MODULE__{}

  schema "ga_data" do
    field :group, :string
    field :type, :string
    field :date, :naive_datetime

    belongs_to :space, Space

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:group, :type, :date, :space_id])
    |> validate_required([:group, :type, :date, :space_id])
  end
end
