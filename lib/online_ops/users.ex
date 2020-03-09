defmodule OnlineOps.Users do
  @moduledoc """
  The Users context.
  """

  import OnlineOps.Gettext

  alias OnlineOps.Email
  alias OnlineOps.Guardian
  alias OnlineOps.Mailer
  alias OnlineOps.Repo
  alias OnlineOps.Schemas.User

  require Logger

  @doc """
  Fetches all spaces for a user.
  """
  @spec get_all() :: {:ok, [User.t()]} | {:error, :not_found}
  def get_all() do
    Repo.all(User)
  end

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
    get_user_changeset(%{email: email})
    |> get_if_valid()
  end

  def get_user_changeset(attrs \\ %{}) do
    User.get_changeset(%User{}, attrs)
  end

  def create_user(attrs \\ %{}) do
    create_user_changeset(attrs)
    |> Repo.insert()
  end

  def create_user_changeset(attrs \\ %{}) do
    User.create_changeset(%User{}, attrs)
  end

  def send_magic_link(%User{} = user) do
    {:ok, magic_token, _claims} = Guardian.encode_magic(user)

    Email.magic_link(magic_token, user)
    |> Mailer.deliver_now()

    {:ok, magic_token}
  end

  defp get_if_valid(%{valid?: false} = changeset) do
    {:error, changeset}
  end

  defp get_if_valid(changeset) do
    case Repo.get_by(User, changeset.changes) do
      nil ->
        {:error, dgettext("errors", "User not found")}

      user ->
        {:ok, user}
    end
  end
end
