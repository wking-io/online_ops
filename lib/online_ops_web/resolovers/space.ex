defmodule OnlineOpsWeb.Resolvers.Space do
  alias OnlineOps.Spaces
  alias Kronky.ValidationMessage

  require Logger

  def create_space(_parent, _args, %{ context: %{ current_user: user }}) do
    case Spaces.create(user, %{state: "SETUP"}) do
      {:ok, %{space: space}} ->
        {:ok, space}

      {:error, changeset} ->
        {:ok, changeset}
    end
  end

  def space(_parent, %{id: id}, %{ context: %{current_user: user }}) do
    case Spaces.get_by_id(user, id) do
      {:ok, data} -> data
      {:error, :resource_not_found} ->
        {:ok, %ValidationMessage{
          code: :resource_not_found,
          field: :space,
          message: "No space found",
        }}
    end
  end

  def list(_parent, _args, %{context: %{current_user: user }}) do
    Spaces.get_all(user)
  end

  def complete_setup_step(_parent, %{id: id, input: %{step: step, selection: selection}}, %{context: %{current_user: user, google_access_token: token}}) do
    user
    |> Spaces.get_by_id(id)
    |> authorize_update_space()
    |> setup_step({step, selection}, token)
  end

  defp authorize_update_space({:ok, %{space_user: space_user}} = result) do
    if Spaces.can_update?(space_user) do
      result
    else
      {:error, {:ok, %ValidationMessage{
        code: :unauthorized,
        field: :space_user,
        message: "User does not have access to update this space.",
      }}}
    end
  end

  defp authorize_update_space(err), do: err

  defp setup_step({:ok, %{space: space}}, step, token), do: Spaces.setup(space, step, token)
  defp setup_step(err, _step, _token), do: err

end
