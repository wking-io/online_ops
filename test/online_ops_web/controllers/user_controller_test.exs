defmodule OnlineOpsWeb.UserControllerTest do
  use OnlineOpsWeb.ConnCase, async: true

  import OnlineOps.Factory

  alias OnlineOps.Users

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
    setup %{conn: conn} do
      params = params_for(:user, %{ email: "test@test.com", last_name: "King" })

      conn =
        conn
        |> post("/signup", %{"user" => params})
      {:ok, %{conn: conn, params: params}}
    end

    test "creates a new user with valid input", %{params: params} do
      case Users.get_by_email(params[:email]) do
        {:ok, user} ->
          assert user.last_name == "King"

        {:error, error} ->
          flunk(error)
      end
    end

    test "user is not logged in yet", %{conn: conn} do
      assert is_nil(conn.assigns[:current_user])
    end

    test "redirects to page explaining magic link was sent to their email", %{conn: conn} do
      assert redirected_to(conn, 302) =~ "/magic"
    end

    test "renders warning with redirect to /signin when using email that is already in use", %{conn: conn} do
      params = params_for(:user, %{ email: "test@test.com" })

      body =
        conn
        |> post("/signup", %{"user" => params})
        |> html_response(200)

      assert body =~ "data-field-error=\"email\""
      assert body =~ "already taken"
    end

    test "renders validation errors when submitting invalid fields", %{conn: conn} do
      params = params_for(:user, %{ email: "invalid", last_name: "" })

      body =
        conn
        |> post("/signup", %{"user" => params})
        |> html_response(200)

      assert body =~ "data-field-error=\"email\""
      assert body =~ "data-field-error=\"last_name\""
    end
  end
end
