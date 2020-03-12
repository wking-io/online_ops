defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  pipeline :maybe_auth do
    plug Guardian.Plug.Pipeline,
      module: OnlineOps.Guardian,
      error_handler: OnlineOpsWeb.GuardianError.JSON
    plug Guardian.Plug.VerifyHeader, claims: %{typ: "access"}, halt: false
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :put_absinthe_context
  end

  # pipeline :anonymous_browser do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :fetch_flash
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  #   plug :maybe_auth
  # end

  # pipeline :ensure_auth do
  #   plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  # end

  # pipeline :authenticated_browser do
  #   plug :anonymous_browser
  #   plug :ensure_auth
  # end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :maybe_auth
  end

  # scope "/" do
  #   pipe_through :api
  #   forward "/graphql", Absinthe.Plug, schema: OnlineOpsWeb.Schema
  # end

  # scope "/", OnlineOpsWeb do
  #   pipe_through [:anonymous_browser, :auth_layout]

  #   get "/signup", UserController, :new
  #   post "/signup", UserController, :create

  #   get "/signin", SessionController, :new
  #   post "/signin", SessionController, :create
  #   get "/signout", SessionController, :destroy

  #   get "/forgot", SessionController, :forgot

  #   get "/magic/initiated", SessionController, :initiated
  #   get "/magic/:magic_token", SessionController, :callback

  # end

  # scope "/", OnlineOpsWeb do
  #   pipe_through [:anonymous_browser, :marketing_layout]

  #   get "/", PageController, :index
  # end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: OnlineOpsWeb.Schema,
      before_send: {OnlineOpsWeb.Plug.Absinthe, :put_refresh_cookie}
  end

  # scope "/auth", OnlineOpsWeb do
  #   pipe_through :anonymous_browser

  #   get "/:provider", AuthController, :request
  #   get "/:provider/callback", AuthController, :callback
  # end

  # scope "/", OnlineOpsWeb do
  #   pipe_through :authenticated_browser

  #   # Important: this must be the last route defined
  #   get "/*path", MainController, :index
  # end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
