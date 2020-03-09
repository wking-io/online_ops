defmodule OnlineOpsWeb.Schema.User do
  @moduledoc false

  use Absinthe.Schema.Notation
  import Kronky.Payload
  import_types Kronky.ValidationMessageTypes
  import_types OnlineOpsWeb.Schema.Scalars

  alias OnlineOpsWeb.Resolvers.User, as: UserResolver

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :inserted_at, non_null(:timestamp)
    field :updated_at, non_null(:timestamp)
  end

  input_object :create_user_params do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
  end

  payload_object(:user_payload, :user)

  object :user_queries do
    field :users, list_of(:user) do
      resolve &UserResolver.list/3
    end
  end

  object :user_mutations do
    field :create_user, type: :user_payload do
      arg :user, :create_user_params
      resolve &UserResolver.create/3
      middleware &build_payload/2
    end
  end
end
