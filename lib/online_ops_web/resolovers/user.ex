defmodule OnlineOpsWeb.Resolvers.User do
  alias OnlineOps.Users

  def list(_parent, _args, _resolution) do
    {:ok, Users.get_all()}
  end

  def find(_parent, %{id: id}, _resolution) do
    Users.get_by_id(id)
  end

  def create(_parent, %{user: args}, _resolution) do
    case Users.create_user(args) do
      {:ok, user} ->
        {:ok, _} = Users.send_magic_link(user)
        {:ok, user}

      {:error, changeset} ->
        {:ok, changeset}
    end
  end
end
