defmodule OnlineOpsWeb.PageController do
  use OnlineOpsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
