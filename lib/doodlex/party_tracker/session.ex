defmodule Doodlex.PartyTracker.Session do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Doodlex.Repo
  alias Doodlex.PartyTracker.Session

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "sessions" do
    field :name, :string
    field :description, :string
    field :alias, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(form, params \\ %{}) do
    form
    |> cast(params, [:name, :description, :alias])
    |> validate_required([:name, :description, :alias])
  end

  def create(attrs) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def get(id) do
    Session
    |> Repo.get(id)
  end

  def get_by_alias(alias) do
    Repo.get_by(Session, alias: alias)
  end


  def all do
    from(s in Session, select: s)
    |> Repo.all()
  end

  def update(id, attrs) do
    case get(id) do
      %Session{} = session ->
        session
        |> Session.changeset(attrs)
        |> Repo.update()

      nil ->
        {:error, "Session not found"}
    end
  end
end

