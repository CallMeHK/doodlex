defmodule Doodlex.Repo.Migrations.AddCharactersTable do
  use Ecto.Migration

  def up do
    create table(:characters) do
      add :character_name, :string, null: false
      add :character_class, :string, null: false
      add :character_heritage, :string, null: false
      add :character_level, :integer, null: false
      add :character_current_hp, :integer, null: false
      add :character_max_hp, :integer, null: false
      add :character_ac, :integer, null: false
      add :character_picture, :string, null: false
      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(:characters)
  end
end
