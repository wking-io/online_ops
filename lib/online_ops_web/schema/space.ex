defmodule OnlineOpsWeb.Schema.Space do
  @moduledoc false

  use Absinthe.Schema.Notation
  alias OnlineOpsWeb.Middleware.Protected
  import Kronky.Payload
  import_types Kronky.ValidationMessageTypes
  import_types OnlineOpsWeb.Schema.Scalars

  alias OnlineOps.Spaces.Connect
  alias OnlineOpsWeb.Resolvers.Space, as: SpaceResolver

  enum :space_step_result do
    value :connect_account, as: "CONNECT_ACCOUNT"
    value :connect_property, as: "CONNECT_PROPERTY"
    value :connect_view, as: "CONNECT_VIEW"
  end

  union :step_data do
    description "Result for the steps to create a space."

    types [:connect_account, :connect_property, :connect_view]
    resolve_types fn
      %Connect.Account{}, _ -> :connect_account
      %Connect.Property{}, _ -> :connect_property
      %Connect.View{}, _ -> :connect_view
    end
  end

  object :space do
    field :id, non_null(:id)
    field :name, :string
    field :inserted_at, non_null(:timestamp)
    field :updated_at, non_null(:timestamp)
  end

  payload_object(:space_payload, :space)

  payload_object(:step_payload, :step_data)

  input_object :space_setup_params do
    field :step, non_null(:setup_step)
    field :selection, :string
  end

  object :space_queries do
    field :spaces, list_of(:space_payload) do
      middleware Protected
      resolve &SpaceResolver.space/3
      middleware &build_payload/2
    end

    field :space, :space_payload do
      arg :id, non_null(:id)
      middleware Protected
      resolve &SpaceResolver.space/3
      middleware &build_payload/2
    end
  end

  object :space_mutations do
    field :create_space, type: :space_payload do
      middleware Protected
      resolve &SpaceResolver.create_space/3
      middleware &build_payload/2
    end

    field :complete_setup_step, type: :step_payload do
      arg :id, non_null(:id)
      arg :input, :space_setup_params
      middleware Protected
      resolve &SpaceResolver.complete_setup_step/3
      middleware &build_payload/2
    end
  end
end
