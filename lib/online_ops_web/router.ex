defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router

  pipeline :anonymous_browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user_by_session
  end

  pipeline :authenticated_browser do
    plug :anonymous_browser
    plug :redirect_unless_signed_in
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug OnlineOpsWeb.AuthPlug
  end

  scope "/", OnlineOpsWeb do
    pipe_through :anonymous_browser

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
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
