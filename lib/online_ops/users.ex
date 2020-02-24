defmodule OnlineOps.Users do
  @moduledoc """
  The Users context.
  """
  
  import OnlineOps.Gettext

  alias OnlineOps.Repo
  alias OnlineOps.Schema.User
  alias OnlineOps.Schema.UserToken

  import Logger

  @doc """
  Fetches a user by id.
  """
  def get_by_id(id) do
    case Repo.get(User, id) do
      %User{} = user ->
        {:ok, user}

      _ ->
        {:error, dgettext("errors", "User not found")}
    end
  end

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      %User{} = user ->
        {:ok, user}
        
      _ ->
        {:error, dgettext("errors", "User not found")}
    end
  end

  def get_all do
    Repo.all(User)
  end

  def create_user(attrs \\ %{}) do
    create_user_changeset(attrs)
    |> Repo.insert()
  end

  def create_user_changeset(attrs \\ %{}) do
    User.changeset(%User{}, attrs)
  end

  def create_user_token(attrs \\ %{}) do
    create_user_token_changeset(attrs)
    |> Repo.insert()
  end

  def create_user_token_changeset(attrs \\ %{}) do
    UserToken.changeset(%UserToken{}, attrs)
  end

  def create_magic(attrs \\ %{}) do
    create_user_token_changeset(attrs)
    |> Repo.insert()
  end

  def validate_magic(id) do
    case Repo.get_by(UserToken, user_id: id) do
      nil ->
        {:error, :not_found}
      
      token ->
        delete_magic(token.id)
        {:ok, :found}
    end
  end

  defp delete_magic(id) do
    user_token = create_user_changeset(%{user_id: id})
    case Repo.delete(user_token) do
      {:ok, _} ->
        {:ok, :token_deleted}
      
      error ->
        error
    end
  end
end