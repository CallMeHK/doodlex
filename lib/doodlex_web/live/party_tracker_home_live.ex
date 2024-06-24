defmodule DoodlexWeb.PartyTrackerLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  use DoodlexWeb, :html

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section id="intro">
            <div class="md-section">
              <p><strong>party tracker</strong> is an interactive, real time application for tracking your fellow role playing gamers character status and metadata. </p>
              <p><a href="/party-tracker/create-character">Create a character</a></p>
              <p><a href="/party-tracker/create-session">Create a session</a></p>
              <p><a href="/party-tracker/join-session">Join a session</a></p>
              <p><a href="/party-tracker/session">Temp Session</a></p>
            </div>
         </section>
      </main>
    """
  end
end
