defmodule OnlineOpsWeb.Plugs.Auth do
  @moduledoc """
  Fetch the current user from the session and add it to `conn.assigns`. This will allow you to have access to the current user in your views with `@current_user`.
  """
  
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    current_user = get_session(conn, :current_user)
    if (is_nil(current_user)) do
      Phoenix.Controller.redirect(to: "/")
    else
      assign(conn, :current_user, current_user)
    end
  end
end