defmodule DoodlexWeb.HomeController do
  use DoodlexWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :index, layout: {DoodlexWeb.Layouts, :base})
  end
end
