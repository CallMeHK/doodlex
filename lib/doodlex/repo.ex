defmodule Doodlex.Repo do
  use Ecto.Repo,
    otp_app: :doodlex,
    adapter: Ecto.Adapters.SQLite3
end
