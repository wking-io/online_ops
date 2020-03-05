defmodule OnlineOpsWeb.AppController do
  use OnlineOpsWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def edit(conn, %{"id" => id}) do
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
          |> redirect(to: Routes.space_path(conn, :index))
    end
  end

  def create(conn, _params) do

    |> render("index.html")
  end

  def update(conn, %{"id" => id}) do
    conn
    |> render("index.html")
  end

  def delete(conn, %{"id" => id}) do
    conn
    |> render("index.html")
  end
end
