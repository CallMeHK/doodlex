defmodule Doodlex.Repo.Migrations.CharacterSessionRelation do
  use Ecto.Migration

  def up do
    alter table(:characters) do
      add :session_id, references(:sessions, on_delete: :nothing)
    end
  end

  def down do
    alter table(:characters) do
      remove :session_id
    end
  end
end
