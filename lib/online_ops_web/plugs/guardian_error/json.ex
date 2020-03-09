defmodule OnlineOpsWeb.GuardianError.JSON do

  import Plug.Conn

  @doc """
  An error handler that processes the errors raised by token checks in Guardian.
  - If resource is not found, returns a 400 response.
  - If unauthorized, halts and returns a 401 response.
  - If invalid, halts and returns a 401 response.
  - If already authenticated, halts and returns a 401 response.
  """
  def auth_error(conn, {:unauthorized, reason}, _opts) do
    conn
      |> assign(:reason, reason)
  end

  def auth_error(conn, {:invalid_token, reason}, _opts) do
    conn
      |> assign(:reason, reason)
  end

  def auth_error(conn, {:already_authenticated, reason}, _opts) do
    conn
      |> assign(:reason, reason)
  end

  def auth_error(conn, {:no_resource_found, reason}, _opts) do
    conn
      |> assign(:reason, reason)
  end
end
