defmodule OnlineOps.Spaces.Connect do
  @moduledoc """
  The module for managing the state of the form when creating a new space.
  """

  alias OnlineOps.Schemas.Space
  alias OnlineOps.Spaces.Property

  @type step :: :connect_account | {:choose_property, SelectList.t(Property.t) } | :choose_view | :complete

  def init() do
    :connect_account
  end

  def create_changeset(attrs \\ %{}) do
    Space.create_changeset(%Space{}, attrs)
  end

  def get_properties({:choose_property, properties}), do: properties

  def is?(:connect_account, :connect_account), do: true
  def is?({:choose_property, _}, :choose_property), do: true
  def is?(:choose_view, :choose_view), do: true
  def is?(:complete, :complete), do: true
  def is?(_, _), do: false
end
