defmodule OnlineOpsWeb.Middleware.CaptureRefresh do
  @behaviour Absinthe.Middleware
  def call(resolution, _) do
    %{ resolution |
      context: Map.put(resolution.context, :refresh_token, resolution.value.refresh_token),
      value: Map.delete(resolution.value, :refresh_token)
    }
  end
end
