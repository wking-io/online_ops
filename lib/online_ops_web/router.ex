defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  pipeline :maybe_auth do
    plug Guardian.Plug.Pipeline,
      module: OnlineOps.Guardian,
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

  pipeline :auth_layout do
    plug :put_layout, {OnlineOpsWeb.LayoutView, :auth}
  end

  pipeline :marketing_layout do
    plug :put_layout, {OnlineOpsWeb.LayoutView, :marketing}
  end

  pipeline :app_layout do
    plug :put_layout, {OnlineOpsWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OnlineOpsWeb do
    pipe_through [:anonymous_browser, :auth_layout]

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    get "/signout", SessionController, :destroy

    get "/forgot", SessionController, :forgot

    get "/magic/initiated", SessionController, :initiated
    get "/magic/:magic_token", SessionController, :callback

  end

  scope "/", OnlineOpsWeb do
    pipe_through [:anonymous_browser, :marketing_layout]

    get "/", PageController, :index
  end

  scope "/app", OnlineOpsWeb do
    pipe_through [:authenticated_browser, :app_layout]

    resources "/spaces", SpacesController
  end

  scope "/auth", OnlineOpsWeb do
    pipe_through :anonymous_browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
