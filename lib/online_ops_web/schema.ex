defmodule OnlineOpsWeb.Schema do
  @moduledoc false

  use Absinthe.Schema

  alias OnlineOpsWeb.Resolvers

  import_types OnlineOpsWeb.Schema.Objects
  import_types OnlineOpsWeb.Schema.Mutations

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    field :viewer, type: :user do
      middleware Protected
      resolve &Resolvers.User.viewer/3
    end

    field :spaces, list_of(:space) do
      middleware Protected
      resolve &Resolvers.Space.space/3
    end

    field :space, :space do
      arg :id, non_null(:id)
      middleware Protected
      resolve &Resolvers.Space.space/3
    end
  end

  mutation do
    field :create_user, type: non_null(:user_payload) do
      arg :input, :create_user_params
      resolve &Resolvers.User.create_user/3
    end

    field :create_session, type: non_null(:user_payload) do
      arg :input, :create_session_params
      resolve &Resolvers.User.create_session/3
    end

    field :authorize_session, type: non_null(:session_payload) do
      arg :input, :magic_token_params
      resolve &Resolvers.User.authorize/3
      middleware CaptureRefresh
    end

    field :refresh_session, type: non_null(:session_payload) do
      resolve &Resolvers.User.refresh/3
      middleware CaptureRefresh
    end

    field :create_space, type: non_null(:space_payload) do
      middleware Protected
      resolve &SpaceResolver.create_space/3
    end

    field :complete_setup_step, type: non_null(:step_payload) do
      arg :id, non_null(:id)
      arg :input, :space_setup_params
      middleware Protected
      resolve &SpaceResolver.complete_setup_step/3
    end
  end
end
