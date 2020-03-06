defmodule OnlineOps.Spaces do
  @moduledoc """
  The Spaces context.
  """

  import OnlineOps.Gettext

  alias OnlineOps.Repo
  alias OnlineOps.Schemas.Space

  @doc """
  Fetches a space by id.
  """
  def get_by_id(id) do
    case Repo.get(Space, id) do
      %Space{} = space ->
        {:ok, space}

      _ ->
        {:error, dgettext("errors", "Space not found")}
    end
  end
end
