defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug OnlineOpsWeb.AuthPlug
  end

  scope "/", OnlineOpsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/auth", OnlineOpsWeb do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  defp assign_current_user(conn, _) do
    current_user = get_session(conn, :current_user)
    if (is_nil(current_user)) do
      redirect(to: "/")
    else
      assign(conn, :current_user, current_user)
    end
  end
end
