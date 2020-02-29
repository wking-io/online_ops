defmodule OnlineOpsWeb.PageControllerTest do
  use OnlineOpsWeb.ConnCase, async: true

  describe "GET /" do
    test "renders the hero CTA", %{conn: conn} do
      body = 
        conn
        |> get("/")
        |> html_response(200)

      assert body =~ "data-cta=\"hero\""
    end
  end
end
