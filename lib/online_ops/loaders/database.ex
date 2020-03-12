defmodule OnlineOps.Loaders.Database do
  @moduledoc false

  import Ecto.Query, warn: false

  alias OnlineOps.Repo
  alias OnlineOps.Spaces
  alias OnlineOps.Schemas.Space
  alias OnlineOps.Schemas.SpaceUser

  # Suppress dialyzer warnings about dataloader functions
  @dialyzer {:nowarn_function, source: 1}

  def source(%{current_user: _user} = params) do
    Dataloader.Ecto.new(Repo, query: &query/2, default_params: params)
  end

  def source(_), do: raise("authentication required")

  # Spaces

  def query(Space, %{current_user: user}), do: Spaces.spaces_base_query(user)
  def query(SpaceUser, %{current_user: user}), do: Spaces.space_users_base_query(user)

  # Fallback

  def query(batch_key, _params) do
    raise("query for " <> to_string(batch_key) <> " not defined")
  end
end
