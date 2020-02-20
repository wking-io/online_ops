defmodule OnlineOpsWeb.Auth do
  @moduledoc """
  Fetch the current user from the session and add it to `conn.assigns`. This will allow you to have access to the current user in your views with `@current_user`.
  """
  
  import Plug.Conn
  import Phoenix.Controller

  def fetch_current_user_by_session(conn, _opts) do
    cond do
      current_user = get_session(conn, :current_user) ->
        assign(conn, :current_user, current_user)
      true ->
        conn
    end
  end
  
  def redirect_unless_signed_in(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> redirect(to: Helpers.auth_path(conn, :new))
      |> halt()
    end
  end
end