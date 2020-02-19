defmodule OnlineOpsWeb.Router do
  use OnlineOpsWeb, :router
  
  alias OnlineOps.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plugs.Auth
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
end
