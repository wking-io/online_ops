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

  def create_user(attrs \\ %{}) do
    create_user_changeset(attrs)
    |> Repo.insert()
  end

  def create_user_changeset(attrs \\ %{}) do
    User.changeset(%User{}, attrs)
  end

  def send_magic_link(%User{} = user) do
    {:ok, magic_token, _claims} = Guardian.encode_magic(user)

    Email.magic_link(magic_token, user)
    |> Mailer.deliver_now()

    {:ok, magic_token}
  end
end