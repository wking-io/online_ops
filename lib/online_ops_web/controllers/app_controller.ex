defmodule OnlineOpsWeb.AppController do
  use OnlineOpsWeb, :controller

  import Logger

  def index(conn, params) do
    Logger.info(inspect conn.assigns)
    conn
    |> render("index.html")
  end
end