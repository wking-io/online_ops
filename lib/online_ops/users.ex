defmodule OnlineOps.Users do
  @moduledoc """
  The Users context.
  """
  
  import OnlineOps.Gettext

  alias OnlineOps.Repo
  alias OnlineOps.Schema.User
  alias OnlineOps.Schema.UserToken

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
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :user_id)
  end

  def create_user_token_changeset(attrs \\ %{}) do
    UserToken.changeset(%UserToken{}, attrs)
  end

  def validate_user_token(id) do
    case Repo.get_by(UserToken, user_id: id) do
      nil ->
        {:error, :not_found}
      
      token ->
        case delete_user_token(token.id) do
          {:ok, _} ->
            {:ok, :found}

          error ->
            {:ok, :found}
        end
    end
  end

  defp delete_user_token(id) do
    Repo.delete(%UserToken{id: id})
  end
end