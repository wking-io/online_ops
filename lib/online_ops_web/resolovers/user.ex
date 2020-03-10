defmodule OnlineOpsWeb.Resolvers.User do
  alias OnlineOps.Users

  alias Kronky.ValidationMessage

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

  def authorize(_parent, %{token: magic_token}, _resolution) do
    case Users.authorize_magic(magic_token) do
      {:ok, user_auth } ->
        {:ok, user_auth}

      {:error, :invalid_token} ->
        {:ok, %ValidationMessage{
          code: :invalid_token,
          field: :magic_token,
          key: :magic_token,
          message: "Invalid token",
        }}

      {:error, :not_found} ->
        {:ok, %ValidationMessage{
          code: :not_found,
          field: :magic_token,
          key: :magic_token,
          message: "Resource not found",
        }}
    end
  end
end
