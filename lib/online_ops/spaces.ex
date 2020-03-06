defmodule OnlineOps.Spaces do
  @moduledoc """
  The Spaces context.
  """

  import Ecto.Query

  alias OnlineOps.Repo
  alias OnlineOps.Schemas.Space
  alias OnlineOps.Schemas.SpaceUser

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
  @spec get_by_id(String.t()) :: {:ok, Space.t()} | {:error, :not_found}
  def get_by_id(id) do
    Repo.get_by(Space, id: id, state: "ACTIVE")
    |> get_response()
  end

  @doc """
  Fetches a space user connected by space and current user.
  """
  @spec get_user(String.t(), String.t()) :: {:ok, SpaceUser.t()} | {:error, :not_authorized}
  def get_user(space_id, user_id) do
    space_users_base_query(space_id, user_id)
    |> Repo.one()
    |> get_response()
  end

  # BASE QUERIES

  @spec spaces_base_query(String.t()) :: Ecto.Query.t()
  defp spaces_base_query(user_id) do
    from s in Space,
      join: su in assoc(s, :space_users),
      where: s.state == "ACTIVE",
      where: su.user_id == ^user_id
  end

  @spec space_users_base_query(String.t(), String.t()) :: Ecto.Query.t()
  defp space_users_base_query(space_id, user_id) do
    from su in SpaceUser,
      distinct: su.id,
      join: s in assoc(su, :space),
      on: su.space_id == ^space_id and su.user_id == ^user_id,
      where: s.state == "ACTIVE",
      where: su.state == "ACTIVE"
  end

  # RESPONSE HANDLERS

  defp get_response(%Space{} = value) do
    {:ok, value}
  end

  defp get_response(%SpaceUser{} = value) do
    {:ok, value}
  end

  defp get_response(value) when is_list(value) do
    if Enum.empty?(value) do
      {:error, :not_found}
    else
      {:ok, value}
    end
  end

  defp get_response(_) do
    {:error, :not_found}
  end
end
