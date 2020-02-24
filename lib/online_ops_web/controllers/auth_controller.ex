defmodule OnlineOpsWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use OnlineOpsWeb, :controller

  import Logger

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def request(conn, %{"provider" => provider}) do
    redirect(conn, external: authorize_url!(provider))
  end

  @doc """
  This action is reached via `/logout` and deletes the current session and redirects to the homepage.
  """
  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)
    # Request the user's data with the access token
    user = get_user(provider, client)

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/dashboard")
  end

  defp authorize_url!("google"), do: Google.authorize_url!(scope: "email profile openid https://www.googleapis.com/auth/analytics.readonly", access_type: "offline")

  defp get_token!("google", code), do: Google.get_token!(code: code)

  defp get_user("google", client) do
    case OAuth2.Client.get(client, "https://people.googleapis.com/v1/people/me?personFields=emailAddresses,names,photos") do
      {:ok, %OAuth2.Response{body: user}} ->
        user
      {:error, %OAuth2.Response{status_code: 401, body: body}} ->
        Logger.error("Unauthorized token: #{inspect body}")
      {:error, %OAuth2.Error{reason: reason}} ->
        Logger.error("Error: #{inspect reason}")
    end
  end
end