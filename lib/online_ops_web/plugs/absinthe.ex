defmodule OnlineOpsWeb.Plug.Absinthe do
  @moduledoc """
  A plug for establishing absinthe context.
  """

  # alias OnlineOps.Loaders
  alias OnlineOps.Schemas.User
  alias Guardian.Plug, as: GuardianBasePlug
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
      build_context()
      |> maybe_user(conn)
      |> maybe_refresh_token(conn)

    Logger.info("Before: " <> inspect context)
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
        Guardian.Plug.put_session_token(conn, token, key: :refresh_token)
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
    case GuardianBasePlug.find_token_from_cookies(conn, key: :refresh_token) do
      :no_token_found ->
        context

      token ->
        Map.put(context, :refresh_token, token)
    end
  end

  def build_context(), do: %{}

  # defp build_loader(params) do
  #   Dataloader.new()
  #   |> Dataloader.add_source(:db, Loaders.database_source(params))
  # end
end
