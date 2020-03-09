defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  pipeline :auth_layout do
    plug :put_layout, {OnlineOpsWeb.LayoutView, :auth}
  end

  pipeline :marketing_layout do
    plug :put_layout, {OnlineOpsWeb.LayoutView, :marketing}
  end

  pipeline :app_layout do
    plug :put_layout, {OnlineOpsWeb.LayoutView, :app}
  end

  pipeline :maybe_auth do
    plug Guardian.Plug.Pipeline,
      module: OnlineOps.Guardian,
      error_handler: OnlineOpsWeb.SessionController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
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

  pipeline :browser_api_without_csrf do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
    plug :fetch_current_user_by_session
  end

  pipeline :graphql do
    plug :fetch_current_user_by_token
    plug :put_absinthe_context
  end

  scope "/" do
    pipe_through :graphql
    forward "/graphql", Absinthe.Plug, schema: OnlineOpsWeb.Schema
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

  scope "/" do
    pipe_through [
      :anonymous_browser,
      :redirect_unless_signed_in
    ]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: OnlineOpsWeb.Schema,
      socket: OnlineOpsWeb.UserSocket,
      default_headers: {__MODULE__, :graphiql_headers},
      default_url: "/graphql"
  end

  scope "/api", OnlineOpsWeb.API do
    pipe_through :browser_api_without_csrf
    resources "/tokens", UserTokenController, only: [:create]
    resources "/reservations", ReservationController, only: [:create]
    resources "/files", FileController, only: [:create]
  end

  scope "/auth", OnlineOpsWeb do
    pipe_through :anonymous_browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", LevelWeb do
    pipe_through :authenticated_browser

    # Important: this must be the last route defined
    get "/*path", MainController, :index
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
