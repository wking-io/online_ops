defmodule OnlineOpsWeb.AppView do
  use OnlineOpsWeb, :view

  def display_user(user) do
    "#{user.first_name} #{user.last_name}"
  end
end
