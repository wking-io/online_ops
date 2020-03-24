defmodule OnlineOps.Spaces do
  @moduledoc """
  The Spaces context.
  """

  import Ecto.Query

  alias OnlineOps.Repo
  alias OnlineOps.Schemas.Space
  alias OnlineOps.Schemas.SpaceUser
  alias OnlineOps.Schemas.User

  @doc """
  Creates a space and space user.
  """
  @spec create(User.t()) :: {:ok, [Space.t()]} | {:error, Changeset.t()}
  def create(%User{} = user, opt []) do
    Space.create_changeset(%Space{}, opts)
    |> Repo.insert()
    |> after_create_space(user)
  end

  defp after_create_space({:ok, %Space{} = space}, %User{} = user) do
    case create_owner(user, space) do
      {:ok, owner} ->
        {:ok, Map.merge(data, %{space_user: owner})}

      err ->
        err
    end
  end

  defp after_create_space(err, _), do: err

  defp create_owner(%User{} = user, %Space{} = space) do
    params = %{
      user_id: user.id,
      space_id: space.id,
      role: "OWNER"
    }

    SpaceUser.create_changeset(%SpaceUser{}, params)
    |> Repo.insert()
  end

  @doc """
  Fetches all spaces for a user.
  """
  @spec get_all(String.t()) :: {:ok, [Space.t()]} | {:error, :not_found}
  def get_all(user_id) do
    spaces_base_query(user_id)
    |> order_by(asc: :name)
    |> Repo.all()
    |> get_response()
  end

  @doc """
  Fetches a space by id.
  """
  @spec get_by_id(User.t(), String.t()) :: {:ok, Space.t()} | {:error, :not_found}
  def get_by_id(user, id) do
    with %Space{} = space <- Repo.get_by(Space, id: id, state: "ACTIVE"),
         {:ok, space_user} <- get_user(user, space) do
      {:ok, %{space: space, space_user: space_user}}
    else
      _ ->
          {:error, :resource_not_found}
    end
  end

  @doc """
  Fetches a space user connected by space and current user.
  """
  @spec get_user(String.t(), String.t()) :: {:ok, SpaceUser.t()} | {:error, :not_authorized}
  def get_user(%User{id: user_id} = user, %Space{ id: space_id}) do
    query = space_users_base_query(user)
    |> where([su], su.space_id == ^space_id and su.user_id == ^user_id)

    case Repo.one(query) do
      %SpaceUser{} = space_user ->
        {:ok, space_user}

      _ ->
        {:error, :resource_not_found}
    end
  end

  # BASE QUERIES

  @doc """
  Builds a query for listing space users related to the given resource.
  """
  @spec space_users_base_query(User.t()) :: Ecto.Query.t()
  @spec space_users_base_query(Space.t()) :: Ecto.Query.t()

  def space_users_base_query(%User{} = user) do
    from su in SpaceUser,
      distinct: su.id,
      join: s in assoc(su, :space),
      join: usu in SpaceUser,
      on: usu.space_id == su.space_id and usu.user_id == ^user.id,
      where: s.state == "ACTIVE",
      where: usu.state == "ACTIVE",
      select: %{su | space_name: s.name}
  end

  def space_users_base_query(%Space{id: space_id}) do
    from su in SpaceUser,
      join: s in assoc(su, :space),
      where: s.state == "ACTIVE",
      where: s.id == ^space_id,
      select: %{su | space_name: s.name}
  end
end
