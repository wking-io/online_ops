defmodule OnlineOpsWeb.Resolvers.Space do
  alias OnlineOps.Spaces
  alias Kronky.ValidationMessage

  require Logger

  def create_space(_parent, _args, %{ current_user: user }) do
    Spaces.create(user)
  end

  def space(_parent, %{id: id}, %{ current_user: user }) do
    case Spaces.get_by_id(user, id) do
      {:ok, data} -> data
      {:error, :resource_not_found} ->
        {:ok, %ValidationMessage{
          code: :resource_not_found,
          field: :space,
          key: :space,
          message: "No space found",
        }}
    end
  end

  def complete_setup_step(_parent, %{id: id, input: data}, _resolution) do
    Spaces.setup(id, data)
  end
end
