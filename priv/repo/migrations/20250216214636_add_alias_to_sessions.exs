defmodule Doodlex.Repo.Migrations.AddAliasToSessions do
  use Ecto.Migration

  def up do
    alter table(:sessions) do
      add :alias, :string, null: true
    end
  end

  def down do
    alter table(:sessions) do
      remove :alias
    end
  end

end
