defmodule OnlineOpsWeb.AuthControllerTest do
  use OnlineOpsWeb.ConnCase

  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "auth/google?scope=email%20profile%20openid%20https://www.googleapis.com/auth/analytics.readonly"
    assert redirected_to(conn, 302)
  end
end