defmodule OnlineOps.Spaces do
  @moduledoc """
  The Spaces context.
  """

  import Ecto.Query

  alias OnlineOps.Repo
  alias OnlineOps.Spaces.Connect
  alias OnlineOps.Schemas.Space
  alias OnlineOps.Schemas.SpaceUser
  alias OnlineOps.Schemas.SpaceAuth
  alias OnlineOps.Schemas.User

  @doc """
  Creates a space and space user.
  """
  @spec create(User.t()) :: {:ok, %{space: Space.t(), space_user: %SpaceUser{}, space_auth: %SpaceAuth{}}} | {:error, Changeset.t()}
  def create(user, opts \\ []) do
    Space.create_changeset(%Space{}, opts)
    |> Repo.insert()
    |> after_create_space(user)
  end

  defp after_create_space({:ok, %Space{} = space}, %User{} = user) do
    with {:ok, owner} <- create_owner(user, space),
         {:ok, auth} <- create_auth(space) do
      {:ok, %{space: space, space_user: owner, space_auth: auth}}
    else
      err ->
        {:error, err}
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

  defp create_auth(%Space{} = space) do
    params = %{
      space_id: space.id,
    }

    SpaceAuth.create_changeset(%SpaceAuth{}, params)
    |> Repo.insert()
  end

  @doc """
  Fetches all spaces for a user.
  """
  @spec get_all(User.t()) :: {:ok, [Space.t()]} | {:error, :resource_not_found}
  def get_all(user) do
    spaces_base_query(user)
      |> order_by(asc: :name)
      |> Repo.all()
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

  @spec setup(String.t(), Connect.step_input(), String.t()) :: Connect.step_output()
  def setup(%Space{} = space, {:connnect_account, _}, token) do
    fetch_options(space, :property, token)
  end

  def setup(%Space{} = space, {:connnect_property, selection}, token) do
    space
    |> Space.update_changeset(%{property: selection})
    |> Repo.update()
    |> fetch_options(:views, token)
  end

  def setup(%Space{} = space, {:connnect_view, selection}, _token) do
    space
    |> Space.update_changeset(%{property: selection})
    |> Repo.update()
  end

  defp fetch_options(%Space{} = space, :property, token) do
    case Connect.fetch(:properties, space, token) do
      {:ok, options} ->
        %Connect.Account{id: space.id, options: options}

      {:error, _} ->
        {:error, :google_error}

    end
  end

  defp fetch_options(%Space{} = space, :view, token) do
    case Connect.fetch(:properties, space, token) do
      {:ok, options} ->
        %Connect.Property{id: space.id, options: options}

      {:error, _} ->
        {:error, :google_error}

    end
  end

  # CONDITIONALS

  @doc """
  Determines if a user is allowed to update a space.
  """
  @spec can_update?(SpaceUser.t()) :: boolean()
  def can_update?(%SpaceUser{role: role}) do
    role == "OWNER" || role == "ADMIN"
  end

  # BASE QUERIES

  @doc """
  Builds a query for listing spaces accessible by a given user.
  """
  @spec spaces_base_query(User.t()) :: Ecto.Query.t()
  def spaces_base_query(user) do
    from s in Space,
      join: su in assoc(s, :space_users),
      where: s.state == "ACTIVE",
      where: su.user_id == ^user.id and su.state == "ACTIVE"
  end

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
