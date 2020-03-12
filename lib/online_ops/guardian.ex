defmodule OnlineOps.Guardian do
  use Guardian, otp_app: :online_ops

  @doc """
  No password authentication helpers
  """

  alias OnlineOps.Users

  require Logger

  @magic "magic"
  @access "access"
  @refresh "refresh"

  def encode_magic(resource, claims \\ %{}) do
    encode_and_sign(resource, claims, token_type: @magic)
  end

  def decode_magic(magic_token, claims \\ %{}) do
    resource_from_token(magic_token, claims, token_type: @magic)
  end

  def encode_access(resource, claims \\ %{}) do
    encode_and_sign(resource, claims, token_type: @access)
  end

  def decode_access(access_token, claims \\ %{}) do
    resource_from_token(access_token, claims, token_type: @access)
  end

  def encode_refresh(resource, claims \\ %{}) do
    encode_and_sign(resource, claims, token_type: @refresh)
  end

  def decode_refresh(access_token, claims \\ %{}) do
    resource_from_token(access_token, claims, token_type: @refresh)
  end

  def exchange_magic(magic_token) do
    with {:ok, _, {access_token, _claims}} <- exchange(magic_token, @magic, @access),
         {:ok, _, {refresh_token, _claims}} <- exchange(magic_token, @magic, @refresh) do
      {:ok, access_token, refresh_token}
    end
  end

  def exchange_refresh(refresh_token) do
    with {:ok, _, {access_token, _claims}} <- exchange(refresh_token, @refresh, @access),
         {:ok, _, {refreshed_token, _claims}} <- refresh(refresh_token) do
      {:ok, access_token, refreshed_token}
    end
  end

  def refresh_access(refresh_token) do
    with {:ok, _, {token, _claims}} <- exchange(refresh_token, @refresh, @access) do
      {:ok, token}
    end
  end

  @doc """
  Guardian implementation
  """

  def subject_for_token(user, _claims) do
    {:ok, "User:" <> to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => "User:" <> id}) do
    case Users.get_by_id(id) do
      {:ok, user} ->
        {:ok, user}

        _ ->
          {:error, :resource_not_found}
    end
  end
end
