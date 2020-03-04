defmodule OnlineOpsWeb.SessionControllerTest do
  use OnlineOpsWeb.ConnCase, async: true

  import OnlineOps.Factory

  alias OnlineOps.Users
  alias OnlineOps.Guardian

  describe "GET /signin" do
    test "renders the signin form", %{conn: conn} do
      body =
        conn
        |> get("/signup")
        |> html_response(200)

      assert body =~ "data-submit=\"signin\""
    end

    test "redirects to dashboard if already logged in", %{conn: conn} do
      user = insert(:user)

      result =
        conn
        |> assign(:current_user, user)
        |> get("/signin")
        |> redirected_to(302)

      assert result =~ "/app"
    end
  end

  describe "POST /signin" do
    setup %{conn: conn} do
      email = %{email: "test@test.com"}
      insert(:user, email)

      conn =
        conn
        |> post("/signin", %{"user" => email})
      {:ok, %{conn: conn, email: email}}
    end

    test "user is not logged in yet", %{conn: conn} do
      assert is_nil(conn.assigns[:current_user])
    end

    test "redirects to page explaining magic link was sent to their email", %{conn: conn} do
      assert redirected_to(conn, 302) =~ "/magic"
    end

    test "redirects to page explaining magic link was sent even if user was not found", %{conn: conn} do
      conn =
        conn
        |> post("/signup", %{"user" => %{email: "invalid"}})

      assert redirected_to(conn, 302) =~ "/magic"
    end

    test "renders validation error when submitting empty email", %{conn: conn} do
      params = params_for(:user, %{ email: "" })

      body =
        conn
        |> post("/signup", %{"user" => params})
        |> html_response(200)

      assert body =~ "data-field-error=\"email\""
    end

    test "renders validation error when submitting invalid email format", %{conn: conn} do
      params = params_for(:user, %{ email: "invalid" })

      body =
        conn
        |> post("/signup", %{"user" => params})
        |> html_response(200)

      assert body =~ "data-field-error=\"email\""
    end
  end

  describe "GET /magic/:magic_token" do
    setup %{conn: conn} do
      email = %{email: "test@test.com"}
      insert(:user, email)

      conn =
        conn
        |> post("/signin", %{"user" => email})
      {:ok, %{conn: conn, token: Guardian.Plug.current_token(conn), email: email.email}}
    end
  end
end
