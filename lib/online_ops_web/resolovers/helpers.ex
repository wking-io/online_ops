defmodule OnlineOpsWeb.Resolvers.Helpers do
  @moduledoc """
  Helpers for GraphQL query resolution.
  """

  def format_errors(%Ecto.Changeset{errors: errors}) do
    Enum.map(errors, fn {field, {msg, props}} ->
      message =
        Enum.reduce(props, msg, fn {k, v}, acc ->
          String.replace(acc, "%{#{k}}", to_string(v))
        end)

      %{code: :invalid_input, field: field, message: message}
    end)
  end
end
