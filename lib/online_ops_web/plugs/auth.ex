# defmodule OnlineOpsWeb.Auth do
#   @moduledoc """
#   Provides user authentication-related plugs and other helper functions
#   """

#   alias OnlineOps.Schemas.User

#   @doc """
#   A plug that looks up the currently logged in user for the current space
#   and assigns it to the `current_user` key. If space is not specified or user is
#   not logged in, sets the `current_user` to `nil`.
#   """
#   def fetch_current_user_by_session(%{assigns: %{current_user: %User{} = user } } = conn, _opts \\ []) do
#     sign_in(conn, user)
#   end

#   def fetch_current_user_by_session(conn, _opts \\ []) do
#     case get_session(conn, :user_id) do
#       nil ->
#         delete_current_user(conn)

#       user_id ->
#         with {:ok, user} <- Users.get_by_id(user_id),
#              true <- user.session_salt == get_session(conn, :salt) do
#           sign_in(conn, user)
#         else
#           delete_current_user(conn)
#         end
#     end
#   end

#   @doc """
#   A plug that authenticates the current user via the `Authorization` bearer token.
#   - If space is not specified, halts and returns a 400 response.
#   - If no token is provided, halts and returns a 401 response.
#   - If token is expired, halts and returns a 401 response.
#   - If token is for a user not belonging to the space in scope, halts and
#     returns a 401 response.
#   - If token is valid, sets the `current_user` on the connection assigns.
#   """
#   def fetch_current_user_by_token(%{assigns: %{current_user: %User{} = user } } = conn, _opts \\ []) do
#     sign_in(conn, user)
#   end

#   def fetch_current_user_by_token(conn, _opts \\ []) do
#     verify_bearer_token(conn)
#   end

#   @doc """
#   Signs a user in.
#   """
#   def sign_in(conn, user) do
#     conn
#     |> put_current_user(user)
#     |> put_session(:user_id, user.id)
#     |> put_session(:salt, user.session_salt)
#   end

#   @doc """
#   Signs a user out.
#   """
#   def sign_out(conn) do
#     conn
#     |> delete_session(:user_id)
#     |> delete_current_user()
#   end

#   @doc """
#   Verifies the signed token and fetches the user record from the database
#   if the token is valid. Otherwise, returns an error.

#   ## Examples

#       get_user_by_token(valid_token)
#       => %{:ok, %{user: user}}

#       get_user_by_token(expired_token)
#       => %{:error, "the error message goes here"}
#   """
#   def get_user_by_token(token) do
#     case verify_signed_jwt(token) do

#     end
#   end

#   @doc """
#   Generates a JSON Web Token (JWT) for a particular user for use by front end
#   clients. Returns a Joken.Token struct. The token is set to expire within 15
#   minutes from generation time.
#   Use the `generate_signed_jwt/1` function to generate a fully-signed
#   token in binary format.
#   """
#   def generate_jwt(user, lifespan_seconds \\ 10 * 60) do
#     %Joken.Token{}
#     |> with_json_module(Poison)
#     |> with_exp(current_time() + lifespan_seconds)
#     |> with_iat(current_time())
#     |> with_nbf(current_time() - 1)
#     |> with_sub(to_string(user.id))
#     |> with_signer(hs256(jwt_secret()))
#   end

#   @doc """
#   Generates a fully-signed JSON Web Token (JWT) for a particular user for use by
#   front end clients.
#   """
#   def generate_signed_jwt(user, lifespan_seconds \\ 10 * 60) do
#     user
#     |> generate_jwt(lifespan_seconds)
#     |> sign
#     |> get_compact
#   end

#   @doc """
#   Verifies a signed JSON Web Token (JWT).
#   """
#   def verify_signed_jwt(signed_token) do
#     signed_token
#     |> token
#     |> with_signer(hs256(jwt_secret()))
#     |> with_validation("exp", &(&1 > current_time()), "Token expired")
#     |> with_validation("iat", &(&1 <= current_time()))
#     |> with_validation("nbf", &(&1 < current_time()))
#     |> verify
#   end

#   @doc """
#   Returns the secret key base to use for signing JSON Web Tokens.
#   """
#   def jwt_secret do
#     Application.get_env(:level, LevelWeb.Endpoint)[:secret_key_base]
#   end

#   defp verify_bearer_token(conn) do
#     case get_req_header(conn, "authorization") do
#       ["Bearer " <> token] ->
#         case get_user_by_token(token) do
#           {:ok, %{user: user}} ->
#             put_current_user(conn, user)

#           {:error, message} ->
#             send_unauthorized(conn, message)
#         end

#       _ ->
#         conn
#         |> delete_current_user()
#         |> send_resp(400, "")
#         |> halt()
#     end
#   end

#   defp send_unauthorized(conn, body) do
#     conn
#     |> delete_current_user()
#     |> send_resp(401, body)
#     |> halt()
#   end

#   defp put_current_user(conn, user) do
#     conn
#     |> assign(:current_user, user)
#   end

#   defp delete_current_user(conn) do
#     assign(conn, :current_user, nil)
#   end
# end

