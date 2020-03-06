defmodule OnlineOpsWeb.UserController do
  use OnlineOpsWeb, :controller

  alias OnlineOps.Users
  alias OnlineOps.Schemas.User

  def new(conn, _params) do
    case conn.assigns[:current_user] do
      %User{} ->
        conn
        |> redirect(to: Routes.spaces_path(conn, :index))

      _ ->
        conn
        |> assign(:changeset, Users.create_user_changeset())
        |> assign(:page_title, "Sign up for OnlineOps")
        |> render("new.html")
    end
  end

  def create(conn, %{"user" => user}) do
    case Users.create_user(user) do
      {:ok, user} ->
        {:ok, _} = Users.send_magic_link(user)
        redirect(conn, to: Routes.session_path(conn, :initiated))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
