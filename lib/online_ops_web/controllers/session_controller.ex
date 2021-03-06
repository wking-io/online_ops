defmodule OnlineOpsWeb.SessionController do
  use OnlineOpsWeb, :controller

  alias OnlineOps.Users
  alias OnlineOps.Schemas.User
  alias OnlineOps.Guardian

  require Logger

  def new(conn, _params) do
    case conn.assigns[:current_user] do
      %User{} ->
        conn
        |> redirect(to: Routes.spaces_path(conn, :index))

      _ ->
        render_sign_in(conn)
    end
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    case Users.get_by_email(email) do
      {:ok, user} ->
        {:ok, _} = Users.send_magic_link(user)
        redirect(conn, to: Routes.session_path(conn, :initiated))

      {:error, %{valid?: false} = changeset} ->
        render_sign_in(conn, changeset)

      {:error, _} ->
        redirect(conn, to: Routes.session_path(conn, :initiated))
    end
  end

  def initiated(conn, _params) do
    render(conn, "magic.html")
  end

  def callback(conn, %{"magic_token" => magic_token}) do
    case Guardian.decode_magic(magic_token) do
      {:ok, user, _claims} ->
        sign_in(conn, user)

      _ ->
        invalid_link(conn)
    end
  end

  def forgot(conn, _params) do
    conn
    |> assign(:changeset, Users.create_user_changeset())
    |> render("forgot.html")
  end

  def destroy(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def auth_error(conn, _error, _opts) do
    conn
    |> put_flash(:error, "Authentication error.")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end

  defp sign_in(conn, user) do
    conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.spaces_path(conn, :index))
  end

  defp invalid_link(conn) do
    conn
        |> put_flash(:error, "Invalid magic link.")
        |> redirect(to: Routes.session_path(conn, :new))
  end

  defp render_sign_in(conn) do
    conn
    |> assign(:changeset, Users.get_user_changeset())
    |> assign(:page_title, "Sign in to OnlineOps")
    |> render("new.html")
  end

  defp render_sign_in(conn, changeset) do
    conn
    |> assign(:changeset, %{changeset | action: :validate})
    |> assign(:page_title, "Sign in to OnlineOps")
    |> render("new.html")
  end
end
