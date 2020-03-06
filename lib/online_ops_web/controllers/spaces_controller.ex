defmodule OnlineOpsWeb.SpacesController do
  use OnlineOpsWeb, :controller

  alias OnlineOps.Spaces

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def edit(conn, %{"id" => _id}) do
    conn
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    case Spaces.get_by_id(id) do
      {:ok, space} ->
        conn
          |> assign(:space, space)
          |> render("space.html")

      {:error, _} ->
        conn
          |> put_flash(:error, "That space does not exist.")
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
