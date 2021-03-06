defmodule OnlineOps.Guardian do
  use Guardian, otp_app: :online_ops

  @doc """
  No password authentication helpers
  """
  
  alias OnlineOps.Users

  @magic "magic"
  @access "access"
  
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
  
  def exchange_magic(magic_token) do
    with {:ok, _, {token, claims}} <- exchange(magic_token, @magic, @access) do
      {:ok, token, claims}
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
      {:ok, user} ->
        {:ok, user}
        
        _ ->
          {:error, :not_found}
    end
  end
end