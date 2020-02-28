defmodule OnlineOps.FactoryCase do
  # with Ecto
  use ExMachina.Ecto, repo: OnlineOps.Repo

  def user_factory do
    %OnlineOps.User{
      first_name: "Jane",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end
end