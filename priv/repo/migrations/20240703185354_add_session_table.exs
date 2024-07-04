defmodule Doodlex.Repo.Migrations.AddSessionTable do
  use Ecto.Migration

  def up do
    create table(:sessions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :description, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop table(:sessions)
  end
end
