defmodule OnlineOpsWeb.Plug.Session do
  alias OnlineOpsWeb.Router.Helpers, as: Routes
  alias OnlineOps.Schemas.User

  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [assign: 3, put_session: 3]

  def ensure_user(%{assigns: %{current_user: %User{}}} = conn, _opts) do
    conn
  end

  def ensure_user(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)

      _ ->
        conn
          |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
