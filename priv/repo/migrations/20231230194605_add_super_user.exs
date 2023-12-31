defmodule Doodlex.Repo.Migrations.AddSuperUser do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :super_user, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:users) do
      remove :super_user
    end
  end
end
