defmodule OnlineOpsWeb.SessionController do
  use OnlineOpsWeb, :controller

  alias OnlineOps.Users
  alias OnlineOps.Schema.User
  alias OnlineOpsWeb.Guardian
  import Logger

  def new(conn, _params) do
    Logger.info(inspect(Users.get_all))
    case conn.assigns[:current_user] do
      %User{} ->
        conn
        |> redirect(to: Routes.app_path(conn, :index))

      _ ->
        conn
        |> assign(:changeset, Users.create_user_changeset())
        |> assign(:page_title, "Sign in to OnlineOps")
        |> render("new.html")
    end
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    case Users.get_by_email(email) do
      {:ok, user} ->
        {:ok, _, _} = Guardian.send_magic_link(user)
        render(conn, "magic.html")
        
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def callback(conn, %{"magic_token" => magic_token}) do
    case Guardian.decode_magic(magic_token) do
      {:ok, {:ok, user}, _claims} ->
        validate_magic(conn, user)

      _ ->
        invalid_link(conn)
    end
  end

  def destroy(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp validate_magic(conn, user) do
    case Users.validate_magic(user.id) do
      {:ok, _} ->
        Logger.info("here")
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.app_path(conn, :index))

      {:error, _} ->
        invalid_link(conn)
    end
  end

  def auth_error(conn, _error, _opts) do
    conn
    |> put_flash(:error, "Authentication error.")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end

  defp invalid_link(conn) do
    conn
        |> put_flash(:error, "Invalid magic link.")
        |> redirect(to: Routes.session_path(conn, :new))
  end
end