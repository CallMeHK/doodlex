defmodule DoodlexWeb.PartyTracker.SessionLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Session
  alias Doodlex.PartyTracker.Components
  use DoodlexWeb, :verified_routes

  def render(assigns) do
    ~H"""
      <main class="container my-8">
        <style>
          @scope {
            :scope {
              .popover-btn  {
                border: 1px solid gray;
                cursor: pointer;
                appearance: none;
                background-color: inherit;
                margin: 0;
                padding: 4px; 
              }
              .session-header {
                display: flex;
                justify-content: space-between;
              }
            }
          }
        </style>
        <script>
          const showPopover = () => document.getElementById("popover-menu").togglePopover()
        </script>
         <section>
            <div class="session-header mb-4">
              <h3 class="mt-3"><%= @session.name %></h3>
              <details class="dropdown mb-0">
                <summary role="button" class="outline"><img src={~p"/images/wrench.svg"} width="32px" height="32px"></summary>
                <ul style="transform: translateX(-75px);">
                  <li><a href={"/party-tracker/session/#{@session.id}/character/create"}>Create Character</a></li>
                </ul>
              </details>
            <div id="popover-menu" popover anchor="wrench-btn">
              <p>I am a popover with more information.</p>
            </div>
            </div>
            <p><%= @session.description %></p>
         </section>
         <section>
          <div class="grid">
            hi
          </div>
         </section>
      </main>
    """
  end

  def mount(%{"session_id" => id}, _session, socket) do
    DoodlexWeb.Endpoint.subscribe("character:1")
    DoodlexWeb.Endpoint.subscribe("session:#{id}")
    maybe_session = Session.get(id) |> IO.inspect
    case maybe_session do
      %Session{} = session ->
        {:ok, assign(socket, session: session, not_found: false )}
      nil ->
        {:ok, assign(socket, not_found: true, session: nil)}
    end
  end

  def handle_info(%{event: "update-character", payload: payload}, socket) do
    IO.puts "--- HANDLE_INFO_SESSION_LIVE"
    IO.inspect payload
    {:noreply, 
    socket }
    #|> assign(character: Map.merge(socket.assigns.character, payload))}
  end
end
