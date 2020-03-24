defmodule OnlineOpsWeb.Schema do
  use Absinthe.Schema

  import_types OnlineOpsWeb.Schema.User
  import_types OnlineOpsWeb.Schema.Space

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    import_fields :user_queries
    import_fields :space_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :space_mutations
  end
end
