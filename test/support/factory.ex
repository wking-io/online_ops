defmodule OnlineOps.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: OnlineOps.Repo
  use OnlineOps.UserFactory
  
end