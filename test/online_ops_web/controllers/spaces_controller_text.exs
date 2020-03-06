defmodule OnlineOpsWeb.SessionControllerTest do
  use OnlineOpsWeb.ConnCase, async: true

  import OnlineOps.Factory

  alias OnlineOps.Guardian

  describe "GET /spaces" do

    test "renders empty state if user does not have any spaces", %{conn: conn} do
      body =
        conn
        |> get("/app/spaces")
        |> html_response(200)

      assert body =~ "data-action=\"first-space\""
    end

    test "renders all spaces", %{conn: conn} do
      conn =
        conn
        |> get("/app/spaces")

      body = html_response(conn, 200)

      assert Enum.empty?(conn.assigns[:spaces]) === false ""

      conn.assigns[:spaces]
      |> Enum.all?(fn space -> space_exists?(body, space) end)
      |> assert
    end
  end

  describe "GET /new" do

    test "create space form is rendered in default state", %{conn: conn} do
      body =
        conn
        |> get("/new")
        |> html_response(200)

      assert body =~ "data-connected=\"false\""
      assert body =~ "data-submit=\"new-space\""
    end

    test "create space form updates when connected to google account", %{conn: conn} do
      body =
        conn
        |> assign(:access_token, "testing_access_token")
        |> get("/new")
        |> html_response(200)

      assert body =~ "data-connected=\"true\""
      assert body =~ "data-field=\"ga_property\""
      assert body =~ "data-submit=\"new-space\""
    end

    test "create space form updates when user selects property", %{conn: conn} do
      body =
        conn
        |> assign(:access_token, "testing_access_token")
        |> get("/new")
        |> html_response(200)

      assert body =~ "data-connected=\"true\""
      assert body =~ "data-field=\"ga_view\""
      assert body =~ "data-submit=\"new-space\""
    end
  end

  describe "POST /spaces" do

    test "redirects to new space if valid", %{conn: conn} do
      result =
        conn
        |> redirected_to(302)

      assert result =~ "/app/spaces/#{space_id}"
    end

    test "renders validation error when missing google account", %{conn: conn, email: email} do
    end

    test "renders validation error when missing google property", %{conn: conn} do
    end

    test "renders validation error when missing google view", %{conn: conn} do
    end
  end
end
