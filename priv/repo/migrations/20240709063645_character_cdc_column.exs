defmodule Doodlex.Repo.Migrations.CharacterCdcColumn do
  use Ecto.Migration

  def up do
    alter table(:characters) do
      add :character_cdc, :integer, null: false
    end
  end

  def down do
    alter table(:characters) do
      remove :character_cdc
    end
  end
end
