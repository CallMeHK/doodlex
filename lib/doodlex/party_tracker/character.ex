defmodule Doodlex.PartyTracker.Character do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Doodlex.Repo
  alias Doodlex.PartyTracker.Character

  schema "characters" do
    field :character_name, :string
    field :character_class, :string
    field :character_heritage, :string
    field :character_picture, :string
    field :character_level, :integer
    field :character_max_hp, :integer
    field :character_current_hp, :integer
    field :character_ac, :integer

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
      :character_ac
    ])
    |> validate_required([
      :character_name,
      :character_class,
      :character_heritage,
      :character_picture,
      :character_level,
      :character_max_hp,
      :character_current_hp,
      :character_ac
    ])
    |> unique_constraint(:character_name)
  end

  def create(%{"character_max_hp" => character_max_hp} = attrs) do
    %Character{}
    |> Character.changeset(Map.merge(%{"character_current_hp" => character_max_hp}, attrs))
    |> Repo.insert()
  end

  def get(id) do
    Character
    |> Repo.get(id)
  end

  def all do 
    from(t in Character, select: t)
    |> Repo.all()
  end
end
