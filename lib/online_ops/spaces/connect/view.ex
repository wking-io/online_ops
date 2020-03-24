defmodule OnlineOps.Spaces.Connect.View do
  alias OnlineOps.Schemas.Space

  @enforce_keys [:id, :space]
  defstruct [:id, :space]

  @type t :: %__MODULE__{
    id: String.t(),
    space: Space.t(),
  }
end
