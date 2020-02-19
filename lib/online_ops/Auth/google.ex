defmodule Google do
  @moduledoc """
  OAuth2 strategy for Google.
  """

  use OAuth2.Stategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: __MODULE__,
     site: "https://accounts.google.com",
     authorize_url: "/o/oauth2/auth",
     token_url: "/o/oauth2/token"
    ]
  end

  def client do
    Application.get_env(:online_ops, Google),
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callback

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
      |> put_param(:client_secret, client.client_secret)
      |> put_header("Accept", "application/json")
      |> AuthCode.get_token(params, headers)
  end
end