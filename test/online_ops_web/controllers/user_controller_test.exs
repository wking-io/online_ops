defmodule OnlineOpsWeb.UserControllerTest do
  use OnlineOpsWeb.ConnCase, async: true

  describe "GET /signup" do
    test "renders the registration form", %{conn: conn} do
      body =
        conn
        |> get("/signup")
        |> html_response(200)

      assert body =~ "data-submit=\"signup\""
    end
  end
end