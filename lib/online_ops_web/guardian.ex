defmodule OnlineOpsWeb.Guardian do
  use Guardian, otp_app: :online_ops
  
  alias OnlineOps.Users

  @doc """
  No password authentication helpers
  """

  @magic "magic"
  @access "access"

  def encode_magic(guardian, resource, claims \\ %{}) do
    guardian.encode_and_sign(resource, claims, token_type: @magic)
  end

  def decode_magic(guardian, magic_token, claims \\ %{}) do
    guardian.resource_from_token(magic_token, claims, token_type: @magic)
  end

  def encode_access(guardian, resource, claims \\ %{}) do
    guardian.encode_and_sign(resource, claims, token_type: @access)
  end

  def decode_access(guardian, access_token, claims \\ %{}) do
    guardian.resource_from_token(access_token, claims, token_type: @access)
  end

  def exchange_magic(guardian, magic_token) do
    with {:ok, _, {token, claims}} <- guardian.exchange(magic_token, @magic, @access) do
      {:ok, token, claims}
    end
  end

  def send_magic_link(guardian, resource, claims \\ %{}, params \\ %{}) do
    with {:ok, magic_token, claims} <- guardian.encode_magic(resource, claims) do
      guardian.deliver_magic_link(resource, magic_token, params)
      {:ok, magic_token, claims}
    end
  end

  @doc """
  Guardian implementation
  """

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_by_id(id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  def deliver_magic_link(_user, magic_token, _opts) do
    require Logger
    alias OnlineOpsWeb.Endpoint
    import OnlineOpsWeb.Router.Helpers

    Logger.info """

    This is the magic link:

      #{auth_url(Endpoint, :callback, magic_token)}

    """
  end
end