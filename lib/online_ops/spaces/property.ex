defmodule OnlineOps.Spaces.Property do
  @moduledoc """
  The module for managing the state of the form when creating a new space.
  """

  @type id :: String.t
  @type name :: String.t
  @type t :: { id, name }
end
