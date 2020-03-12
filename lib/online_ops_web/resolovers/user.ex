defmodule OnlineOpsWeb.Resolvers.User do
  alias OnlineOps.Users
  alias Kronky.ValidationMessage

  require Logger

  def viewer(_parent, _args, %{ context: %{ current_user: user }}) do
    case Users.get_profile(user) do
      {:ok, profile} ->
        {:ok, profile}

      {:error, :resource_not_found} ->
        {:ok, %ValidationMessage{
          code: :resource_not_found,
          field: :viewer,
          key: :viewer,
          message: "No user found",
        }}
    end
  end

  def viewer(_parent, _args, _resolution) do
    {:ok, %ValidationMessage{
      code: :unauthorized,
      field: :bearer,
      key: :bearer,
      message: "Invalid authorization token",
    }}
  end

  def list(_parent, _args, _resolution) do
    {:ok, Users.get_all()}
  end

  def find(_parent, %{id: id}, _resolution) do
    Users.get_by_id(id)
  end

  def create_user(_parent, %{input: args}, _resolution) do
    case Users.create_user(args) do
      {:ok, user} ->
        {:ok, _} = Users.send_magic_link(user)
        {:ok, user}

      {:error, changeset} ->
        {:ok, changeset}
    end
  end

  def create_session(_parent, %{input: %{email: email}}, _resolution) do
    case Users.get_by_email(email) do
      {:ok, user} ->
        {:ok, _} = Users.send_magic_link(user)
        {:ok, user}

      {:error, %{valid?: false} = changeset} ->
        {:ok, changeset}

      {:error, :resource_not_found} ->
        {:ok, %ValidationMessage{
          code: :resource_not_found,
          field: :email,
          key: :email,
          message: "No user found",
        }}
    end
  end

  def authorize(_parent, %{input: magic_token}, _resolution) do
    case Users.authorize_magic(magic_token) do
      {:ok, user_auth} ->
        {:ok, user_auth}

      {:error, :invalid_token} ->
        {:ok, %ValidationMessage{
          code: :invalid_token,
          field: :magic_token,
          key: :magic_token,
          message: "Invalid token",
        }}

      {:error, :resource_not_found} ->
        {:ok, %ValidationMessage{
          code: :resource_not_found,
          field: :magic_token,
          key: :magic_token,
          message: "Resource not found",
        }}

      {:error, :secret_not_found} ->
        {:ok, %ValidationMessage{
          code: :secret_not_found,
          field: :magic_token,
          key: :magic_token,
          message: "Secret not found",
        }}

      {:error, :no_token} ->
        {:ok, %ValidationMessage{
          code: :no_token,
          field: :magic_token,
          key: :magic_token,
          message: "Token was somehow missed",
        }}

      {:error, error} ->
        Logger.error(inspect error)
        {:ok, %ValidationMessage{
          code: :unknown,
          field: :magic_token,
          key: :magic_token,
          message: "Unknown error check logs",
        }}
    end
  end

  def refresh(_parent, _args, %{ context: %{ refresh_token: refresh_token }}) do
    case Users.authorize_refresh(refresh_token) do
      {:ok, user_auth} ->
        {:ok, user_auth}

      {:error, :invalid_token} ->
        {:ok, %ValidationMessage{
          code: :invalid_token,
          field: :refresh_token,
          key: :refresh_token,
          message: "Invalid token",
        }}

      {:error, :resource_not_found} ->
        {:ok, %ValidationMessage{
          code: :resource_not_found,
          field: :refresh_token,
          key: :refresh_token,
          message: "Resource not found",
        }}

      {:error, :secret_not_found} ->
        {:ok, %ValidationMessage{
          code: :secret_not_found,
          field: :refresh_token,
          key: :refresh_token,
          message: "Secret not found",
        }}

      {:error, :no_token} ->
        {:ok, %ValidationMessage{
          code: :no_token,
          field: :refresh_token,
          key: :refresh_token,
          message: "Token was somehow missed",
        }}

      {:error, _} ->
        {:ok, %ValidationMessage{
          code: :unknown,
          field: :refresh_token,
          key: :refresh_token,
          message: "Unknown error check logs",
        }}
    end
  end

  def refresh(_parent, _args, _resolution) do
    {:ok, %ValidationMessage{
      code: :no_token,
      field: :refresh_token,
      key: :refresh_token,
      message: "Token was somehow missed",
    }}
  end
end
