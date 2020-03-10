defmodule OnlineOpsWeb.Plug.Absinthe do
  @moduledoc """
  A plug for establishing absinthe context.
  """

  alias OnlineOps.Loaders
  alias OnlineOps.Schemas.User

  # Suppress dialyzer warnings about dataloader functions
  @dialyzer {:nowarn_function, build_loader: 1}

  @doc """
  Sets absinthe context on the given connection.
  """
  def put_absinthe_context(conn, _) do
    current_user = Guardian.Plug.current_resource(conn)
    Absinthe.Plug.put_options(conn, context: build_context(current_user))
  end

  def build_context(%User{} = user) do
    %{current_user: user, loader: build_loader(%{current_user: user})}
  end

  def build_context(_), do: %{}

  defp build_loader(params) do
    Dataloader.new()
    |> Dataloader.add_source(:db, Loaders.database_source(params))
  end
end
