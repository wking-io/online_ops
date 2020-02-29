defmodule OnlineOpsWeb.UserControllerTest do
  use OnlineOpsWeb.ConnCase, async: true

  import OnlineOps.Factory

  describe "GET /signup" do
    test "renders the registration form", %{conn: conn} do
      body =
        conn
        |> get("/signup")
        |> html_response(200)

      assert body =~ "data-submit=\"signup\""
    end

    test "redirects to dashboard if already logged in", %{conn: conn} do
      user = insert(:user)

      result =
        conn
        |> assign(:current_user, user)
        |> get("/signup")
        |> redirected_to(302)

      assert result =~ "/app"
    end
  end

  describe "POST /signup" do
    test "creates a new user with valid input" do
    end

    test "creates magic link email with valid input" do
    end

    test "shows warning with redirect to /signin when using email that is already in use" do
      
    end
  end
end