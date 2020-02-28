defmodule OnlineOpsWeb.AppController do
  use OnlineOpsWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end