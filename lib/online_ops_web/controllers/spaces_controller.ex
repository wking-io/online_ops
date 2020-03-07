defmodule OnlineOpsWeb.SpacesController do
  use OnlineOpsWeb, :controller

  alias OnlineOps.Spaces
  alias OnlineOps.Spaces.Connect

  def index(conn, _params) do
    case Spaces.get_all(conn.assigns[:current_user_id]) do
      {:ok, spaces} ->
        conn
        |> assign(:spaces, spaces)
        |> render("index.html")

      {:error, :not_found} ->
        conn
        |> render("index.html")
    end
  end

  def edit(conn, %{"id" => _id}) do
    conn
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Connect.create_changeset())
    |> assign(:state, Connect.init())
    |> render("new.html")
  end

  def show(conn, %{"id" => id}) do
    with(
      {:ok, space} <- Spaces.get_by_id(id),
      {:ok, space_user} <- Spaces.get_user(id, conn.assigns[:current_user_id])
    ) do
      conn
        |> assign(:space, space)
        |> assign(:current_space_user, space_user)
        |> render("space.html")
    else
      {:error, :not_found} ->
        conn
          |> put_flash(:error, "That space does not exist.")
          |> redirect(to: Routes.spaces_path(conn, :index))

      {:error, :not_authorized} ->
        conn
          |> redirect(to: Routes.spaces_path(conn, :index))
    end
  end

  def create(conn, _params) do
    conn
    |> render("index.html")
  end

  def update(conn, %{"id" => _id}) do
    conn
    |> render("index.html")
  end

  def delete(conn, %{"id" => _id}) do
    conn
    |> render("index.html")
  end
end
