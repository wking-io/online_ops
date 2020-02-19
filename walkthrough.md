%Conn{}
|> put_session()

Send the user to Google to login
They hit your callback URL with a code
Exchange code for an access token
Exchange access token for a refresh token
Store the refresh token in your database attached to the account

To make an API call:
Refresh the token to get an access token
Use the access token to make the call

user |> login |> redirect to google auth request url |> user authorizes |> callback |> pull data we need for creating user and making requests |> access token for immediate requests and refresh for storage