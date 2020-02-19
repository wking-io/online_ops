defmodule OnlineOps.Repo do
  use Ecto.Repo,
    otp_app: :online_ops,
    adapter: Ecto.Adapters.Postgres
end
