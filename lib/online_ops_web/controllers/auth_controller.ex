defmodule OnlineOpsWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use OnlineOpsWeb, :controller
  plug Ueberauth
  
  alias Ueberauth.Strategy.Helpers
end