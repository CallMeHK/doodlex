# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Doodlex.Repo.insert!(%Doodlex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Doodlex.Accounts

Accounts.register_super_user(%{email: "hkrazy888@gmail.com", password: System.get_env("SU_PW")})
Accounts.register_user(%{email: "yeet@gmail.com", password: System.get_env("USER_PW")})
Accounts.register_user(%{email: "skeet@gmail.com", password: System.get_env("USER_PW")})
