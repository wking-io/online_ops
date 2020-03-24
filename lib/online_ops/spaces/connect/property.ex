defmodule OnlineOps.Spaces.Connect.Property do
  @enforce_keys [:id, :options]
  defstruct [:id, :options]

  @type t :: %__MODULE__{
    id: String.t(),
    options: [{String.t, String.t}],
  }
end
