defmodule OnlineOpsWeb.Schema.Enums do
  @moduledoc false

  use Absinthe.Schema.Notation

  enum :setup_step do
    value :connect_account, as: "CONNECT_ACCOUNT"
    value :connect_property, as: "CONNECT_PROPERTY"
    value :connect_view, as: "CONNECT_VIEW"
  end
end
