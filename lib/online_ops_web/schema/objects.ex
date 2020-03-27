defmodule OnlineOpsWeb.Schema.Objects do
  @moduledoc false

  use Absinthe.Schema.Notation

  import_types OnlineOpsWeb.Schema.Enums
  import_types OnlineOpsWeb.Schema.Scalars
  import_types OnlineOpsWeb.Schema.InputObjects

  object :user do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :inserted_at, non_null(:timestamp)
    field :updated_at, non_null(:timestamp)
  end

  object :session do
    field :access_token, non_null(:string)
    field :user, non_null(:user)
  end

  object :space do
    field :id, non_null(:id)
    field :name, :string
    field :inserted_at, non_null(:timestamp)
    field :updated_at, non_null(:timestamp)
  end

  union :step_data do
    description "Result for the steps to create a space."

    # TODO: Fix the structs to be schema for space_setup_step db
    types [:connect_account, :connect_property, :connect_view]
    resolve_types fn
      %Connect.Account{}, _ -> :connect_account
      %Connect.Property{}, _ -> :connect_property
      %Connect.View{}, _ -> :connect_view
    end
  end

  object :connect_account do
    field :id, non_null(:id)
    field :options, list_of(:setup_option)
  end

  object :connect_property do
    field :id, non_null(:id)
    field :options, list_of(:setup_option)
  end

  object :connect_view do
    field :id, non_null(:id)
  end

  object :setup_option do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end
end
