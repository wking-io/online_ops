defmodule OnlineOpsWeb.MainController do
  @moduledoc false

  use OnlineOpsWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:module, "main")
    |> render("index.html")
  end
end
