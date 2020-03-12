defmodule OnlineOpsWeb.Schema do
  use Absinthe.Schema

  import_types OnlineOpsWeb.Schema.User

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end
end
