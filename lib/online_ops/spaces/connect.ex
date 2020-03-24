defmodule OnlineOps.Spaces.Connect do
  alias Connect.{Account, Property, View}

  @type step_input :: {:connect_account, String.t()} | {:connect_properties, String.t()} | {:connect_view, String.t()}
  @type step_output :: Account.t() | Property.t() | View.t()

  def fetch(token, :property, token) do
    {:ok, []}
  end

  def fetch(token, :view, token) do
    {:ok, []}
  end

  def fetch(_, _, _) do
    {:error, :invalid_resource}
  end
end
