defmodule OnlineOpsWeb.Plug.Absinthe do
  @moduledoc """
  A plug for establishing absinthe context.
  """

  import Plug.Conn
  alias OnlineOps.Loaders
  alias OnlineOps.Schemas.User
  alias OnlineOps.Guardian
  alias Absinthe.Blueprint

  require Logger

  # Suppress dialyzer warnings about dataloader functions
  @dialyzer {:nowarn_function, build_loader: 1}

  @doc """
  Sets absinthe context on the given connection.
  """
  def put_absinthe_context(conn, _) do
    context =
      %{}
      |> maybe_user(conn)
      |> maybe_loader()
      |> maybe_refresh_token(conn)
      |> maybe_google_access_token(conn)

    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Sets the refresh cookie on the given connection
  """
  def put_refresh_cookie(conn, %Blueprint{ execution: %Blueprint.Execution{ context: context } }) do
    case context[:refresh_token] do
      nil ->
        conn

      token ->
        put_session(conn, :refresh_token, token)
    end
  end

  defp maybe_user(context, conn) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user ->
        Map.put(context, :current_user, user)

      _ ->
        context
    end
  end

  defp maybe_refresh_token(context, conn) do
    case get_session(conn, :refresh_token) do
      nil ->
        context

      token ->
        Map.put(context, :refresh_token, token)
    end
  end

  defp maybe_google_access_token(context, conn) do
    case get_session(conn, :google_access_token) do
      nil ->
        context

      token ->
        Map.put(context, :google_access_token, token)
    end
  end

  defp maybe_loader(%{ current_user: user } = context) do
    Map.put(context, :loader, build_loader(%{current_user: user}))
  end

  defp maybe_loader(context) do
    context
  end

  defp build_loader(params) do
    Dataloader.new()
    |> Dataloader.add_source(:db, Loaders.database_source(params))
  end
end
