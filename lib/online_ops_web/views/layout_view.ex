defmodule OnlineOpsWeb.LayoutView do
  use OnlineOpsWeb, :view

  def asset_from_module(module) do
    module
    |> to_string()
    |> String.replace(["Elixir.OnlineOpsWeb.", "View"], "")
    |> String.downcase()
  end
end
