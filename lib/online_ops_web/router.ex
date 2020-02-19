defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  defmodule OnlineOpsWeb.AuthPlug do
    use Plug

    def call(conn, opts \\ []) do
      user_id = get_session(conn, :user_id)
      if is_nil(user_id) do
        redirect(conn, to: "/login")
      else
        user = Accounts.get_user(user_id)
        conn
        |> assign(:user_id, user_id)
        |> assign(:user, user)
      end
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", OnlineOpsWeb do
  #   pipe_through :api
  # end
end
