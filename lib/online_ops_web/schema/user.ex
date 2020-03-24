defmodule OnlineOpsWeb.Schema.User do
  @moduledoc false

  use Absinthe.Schema.Notation
  alias OnlineOpsWeb.Middleware.{Protected, CaptureRefresh}
  import Kronky.Payload
  import_types Kronky.ValidationMessageTypes
  import_types OnlineOpsWeb.Schema.Scalars

  alias OnlineOpsWeb.Resolvers.User, as: UserResolver

  require Logger

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :inserted_at, non_null(:timestamp)
    field :updated_at, non_null(:timestamp)
  end

  object :user_profile do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
  end

  payload_object(:user_payload, :user_profile)

  input_object :create_user_params do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
  end

  input_object :create_session_params do
    field :email, non_null(:string)
  end

  input_object :magic_token_params do
    field :token, non_null(:string)
  end

  object :user_auth do
    field :access_token, non_null(:string)
    field :user, non_null(:user_profile)
  end

  payload_object(:user_auth_payload, :user_auth)

  object :user_queries do
    field :viewer, type: :user_payload do
      middleware Protected
      resolve &UserResolver.viewer/3
      middleware &build_payload/2
    end
  end

  object :user_mutations do
    field :create_user, type: :user_payload do
      arg :input, :create_user_params
      resolve &UserResolver.create_user/3
      middleware &build_payload/2
    end

    field :create_session, type: :user_payload do
      arg :input, :create_session_params
      resolve &UserResolver.create_session/3
      middleware &build_payload/2
    end

    field :authorize_user, type: :user_auth_payload do
      arg :input, :magic_token_params
      resolve &UserResolver.authorize/3
      middleware CaptureRefresh
      middleware &build_payload/2
    end

    field :refresh_session, type: :user_auth_payload do
      resolve &UserResolver.refresh/3
      middleware CaptureRefresh
      middleware &build_payload/2
    end
  end
end
