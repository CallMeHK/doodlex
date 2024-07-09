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
alias Doodlex.PartyTracker.Session
alias Doodlex.PartyTracker.Character

Accounts.register_super_user(%{email: "hkrazy888@gmail.com", password: System.get_env("SU_PW") || "asdfasdfasdf"})
Accounts.register_user(%{email: "yeet@gmail.com", password: System.get_env("USER_PW") || "asdfasdfasdf"})
Accounts.register_user(%{email: "skeet@gmail.com", password: System.get_env("USER_PW") || "asdfasdfasdf"})

{:ok, %{id: session_id}} = Session.create(%{name: "Test Session", description: "A description of a test campaign."})
Session.create(%{name: "Blank Test Session", description: "A blank campaign"})

Character.create(%{
  character_name: "Gimli",
  character_class: "Champion",
  character_heritage: "Dwarf",
  character_picture: "https://assetsio.gnwcdn.com/gimli_OVQOp6S.jpg?width=1200&height=1200&fit=bounds&quality=70&format=jpg&auto=webp",
  character_level: 3,
  character_max_hp: 35,
  character_current_hp: 25,
  character_ac: 19,
  character_cdc: 16,
  session_id: session_id
})

Character.create(%{
  character_name: "Legolas",
  character_class: "Ranger",
  character_heritage: "Elf",
  character_picture: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQt3fv9-DsoMcoCzgzHJLFuqCRS7HEseV_vBw&s",
  character_level: 3,
  character_max_hp: 30,
  character_current_hp: 30,
  character_ac: 18,
  character_cdc: 17,
  session_id: session_id
})

Character.create(%{
  character_name: "Frodo",
  character_class: "Rogue",
  character_heritage: "Halfling",
  character_picture: "https://www.christopherfenoglio.com/wp-content/uploads/2012/12/Frodo-800x357-1.jpg",
  character_level: 3,
  character_max_hp: 25,
  character_current_hp: 25,
  character_ac: 19,
  character_cdc: 16,
  session_id: session_id
})

Character.create(%{
  character_name: "Boromir",
  character_class: "Fighter",
  character_heritage: "Human",
  character_picture: "https://lisasoddthoughts.com/wp-content/uploads/2021/01/lord-of-the-rings-sean-bean-boromir-1584636601-1200x675.jpg",
  character_level: 3,
  character_max_hp: 32,
  character_current_hp: 8,
  character_ac: 18,
  character_cdc: 17,
  session_id: session_id
})

Character.create(%{
  character_name: "Gandalf",
  character_class: "Wizard",
  character_heritage: "Human",
  character_picture: "https://cdn.vox-cdn.com/thumbor/3-aTzyoIvirEUDABoLUCTjv84LY=/1400x1400/filters:format(jpeg)/cdn.vox-cdn.com/uploads/chorus_asset/file/22326168/gandalf_shire_lord_of_the_rings.jpg",
  character_level: 5,
  character_max_hp: 43,
  character_current_hp: 15,
  character_ac: 17,
  character_cdc: 19,
  session_id: session_id
})
