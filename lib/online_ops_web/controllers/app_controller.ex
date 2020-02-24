defmodule OnlineOpsWeb.AppController do
  use OnlineOpsWeb, :controller

  alias OnlineOpsWeb.Guardian

  def index(conn, params) do
    conn
    |> render("index.html")
  end
end