defmodule DoodlexWeb.PartyTrackerLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  use DoodlexWeb, :html

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section id="intro">
            <div class="md-section">
              <p><strong>party tracker</strong> is an interactive, real time application for tracking your fellow role playing gamers character status and metadata. Ask your DM for a link to your party's session.</p>
              <%= if @is_super do %>
              <p><a href="/party-tracker/create-character">Create a character</a></p>
              <p><a href="/party-tracker/create-session">Create a session</a></p>
              <p><a href="/party-tracker/join-session">Join a session</a></p>
              <p><a href="/party-tracker/session/all">All Sessions</a></p>
              <% end %>
            </div>
         </section>
      </main>
    """
  end


  def mount(params, session, socket) do
    IO.inspect socket.assigns.current_user
    is_super = if socket.assigns.current_user == nil do
      false
    else
      socket.assigns.current_user.super_user
    end

    {:ok, 
      socket
      |> assign(is_super: is_super )
    }
  end
end
