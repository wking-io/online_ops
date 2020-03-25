defmodule OnlineOpsWeb.Middleware.Protected do
  @behaviour Absinthe.Middleware
  alias Kronky.ValidationMessage
  require Logger
  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:ok, unauthenticated()})
    end
  end

  defp unauthenticated() do
    %ValidationMessage{
      code: :unauthorized,
      field: :bearer,
      message: "Invalid authorization token",
    }
  end
end
