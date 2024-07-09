defmodule Doodlex.PartyTracker.Character do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Doodlex.Repo
  alias Doodlex.PartyTracker.Character
  alias Doodlex.PartyTracker.Session

  schema "characters" do
    field :character_name, :string
    field :character_class, :string
    field :character_heritage, :string
    field :character_picture, :string
    field :character_level, :integer
    field :character_max_hp, :integer
    field :character_current_hp, :integer
    field :character_ac, :integer
    field :character_cdc, :integer
    field :session_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(form, params \\ %{}) do
    form
    |> cast(params, [
      :character_name,
      :character_class,
      :character_heritage,
      :character_picture,
      :character_level,
      :character_max_hp,
      :character_current_hp,
      :character_ac,
      :character_cdc,
      :session_id
    ])
    |> validate_required([
      :character_name,
      :character_class,
      :character_heritage,
      :character_picture,
      :character_level,
      :character_max_hp,
      :character_current_hp,
      :character_ac,
      :character_cdc,
      :session_id
    ])
    |> unique_constraint(:character_name)
  end

  def create(%{"character_max_hp" => character_max_hp} = attrs) do
    %Character{}
    |> Character.changeset(Map.merge(%{"character_current_hp" => character_max_hp}, attrs))
    |> Repo.insert()
  end

  def create(%{character_max_hp: _} = attrs) do
    map_with_strings =
      for {key, value} <- attrs do
        {Atom.to_string(key), value}
      end
  |> Map.new()
  create(map_with_strings)
  end

  def get(id) do
    Character
    |> Repo.get(id)
  end

  def update(id, changes) do
    case get(id) do
      %Character{} = character ->
        character
        |> Character.changeset(changes)
        |> Repo.update()
      nil ->
          {:error, "User not found"}
      end
  end

  def all do 
    from(t in Character, select: t)
    |> Repo.all()
  end

  def get_by_session(session_id) do
    from(c in Character,
      where: c.session_id == ^session_id,
      select: c
    )
    |> Repo.all()
  end

  def update_hp(id, change) do
    case get(id) do
      %Character{} = character ->
        max_hp = character.character_max_hp
        hp = character.character_current_hp
        maybe_new_hp = hp + change
        new_current_hp = cond do
          maybe_new_hp > max_hp -> max_hp
          maybe_new_hp < 0 -> 0
          true -> maybe_new_hp
        end
        IO.puts "--- UPDATE_HP"
        IO.inspect {hp, change, maybe_new_hp, new_current_hp}
        character
        |> Character.changeset(%{character_current_hp: new_current_hp})
        |> Repo.update()

        nil ->
          {:error, "User not found"}
      end
  end
end
