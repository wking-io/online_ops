defmodule OnlineOpsWeb.ErrorController do
  use OnlineOpsWeb, :controller

  def auth_error(conn, _error, _opts) do
    conn
    |> put_flash(:error, "Authentication error.")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end
