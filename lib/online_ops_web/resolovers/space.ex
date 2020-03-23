defmodule OnlineOpsWeb.Resolvers.Space do
  alias OnlineOps.Spaces
  alias Kronky.ValidationMessage

  require Logger

  def create_space(_parent, %{input: input}, _resolution) do
    Spaces.create(input)
  end

  def space(_parent, %{id: id}, _resolution) do
    Spaces.get_by_id(id)
  end

  def complete_setup_step(_parent, %{id: id, input: data}, _resolution) do
    Spaces.setup(id, data)
  end
end
