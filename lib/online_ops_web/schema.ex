defmodule OnlineOpsWeb.Schema do
  use Absinthe.Schema

  import_types OnlineOpsWeb.Schema.User

  query do
    @desc "The currently authenticated user."
    field :viewer, :user do
      resolve(fn _, %{context: %{current_user: current_user}} ->
        {:ok, current_user}
      end)
    end

    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end
end
