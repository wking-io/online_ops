defmodule OnlineOpsWeb.AppController do
  use OnlineOpsWeb, :controller

  alias OnlineOpsWeb.Guardian
  import Logger

  def index(conn, params) do
    Logger.info(inspect Guardian.Plug.current_resource(conn))
    conn
    |> render("index.html")
  end
end