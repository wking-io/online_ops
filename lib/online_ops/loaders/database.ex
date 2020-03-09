defmodule Level.Loaders.Database do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Level.Repo

  # Suppress dialyzer warnings about dataloader functions
  @dialyzer {:nowarn_function, source: 1}

  def source(%{current_user: _user} = params) do
    Dataloader.Ecto.new(Repo, query: &query/2, default_params: params)
  end

  def source(_), do: raise("authentication required")

  # Fallback

  def query(batch_key, _params) do
    raise("query for " <> to_string(batch_key) <> " not defined")
  end
end
