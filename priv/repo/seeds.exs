# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OnlineOps.Repo.insert!(%OnlineOps.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias OnlineOps.Users

Users.create_user(%{
  email: "contact@test.io",
  first_name: "Will",
  last_name: "King"
})
