defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  pipeline :maybe_auth do
    plug Guardian.Plug.Pipeline,
      module: OnlineOpsWeb.Guardian,
      error_handler: OnlineOpsWeb.SessionController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :anonymous_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :maybe_auth
  end
  
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug :ensure_user
  end

  pipeline :authenticated_browser do
    plug :anonymous_browser
    plug :ensure_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OnlineOpsWeb do
    pipe_through :anonymous_browser

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    get "/signin/:magic_token", SessionController, :callback
    get "/signout", SessionController, :destroy
  end

  scope "/app", OnlineOpsWeb do
    pipe_through :authenticated_browser

    get "/", AppController, :index
  end

  scope "/auth", OnlineOpsWeb do
    pipe_through :anonymous_browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
