defmodule DoodlexWeb.HomeController do
  use DoodlexWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    IO.puts("-------- CONTROLLER ------------------------------------------")
    IO.inspect(conn.assigns)

    render(conn, :index, current_user: conn.assigns.current_user, layout: {DoodlexWeb.Layouts, :base})
  end
end

