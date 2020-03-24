defmodule Online_Ops_Web.Protected do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, unauthenticated()})
    end
  end

  defp unauthenticated() do
    {:ok, %ValidationMessage{
      code: :unauthorized,
      field: :bearer,
      key: :bearer,
      message: "Invalid authorization token",
    }}
  end
end
