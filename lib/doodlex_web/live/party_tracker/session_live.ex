defmodule DoodlexWeb.PartyTracker.SessionLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Session
  alias Doodlex.PartyTracker.Character
  alias Doodlex.PartyTracker.Components
  use DoodlexWeb, :verified_routes

  def render(assigns) do
    ~H"""
    <div>
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
              .character-img-tray {
                width: 400px; 
                height:300px;
                background-color: #f0ecec;
              }
              .character-img-tray img {
                height:100%; 
                width:100%;
                object-fit: contain;
              }
              .character-card {
                margin-left: 20px;
                margin-right: 20px;
              }
              .characters {
                display: flex;
                flex-wrap: wrap;
                margin: 8px;
                justify-content: center;
                max-width:2200px;
              }
              .character-card-header {
                display: flex;
                justify-content: space-between;
              }
            }
          }
        </style>
      <main class="container my-8">
         <section>
            <div class="session-header mb-4">
              <h3 class="mt-3"><%= @session.name %></h3>
              <details class="dropdown mb-0">
                <summary role="button" class="outline"><img src={~p"/images/wrench.svg"} width="32px" height="32px"></summary>
                <ul style="transform: translateX(-75px);">
                  <li><a href={"/party-tracker/session/#{@session.id}/character/create"}>Create Character</a></li>
                </ul>
              </details>
            </div>
            <p><%= @session.description %></p>
         </section>
      </main>
      <div class="characters">
      <%= for character <- @characters do %>
        <article class="character-card">
          <header class="character-card-header">
            <div class="flex justify-center items-center">
              <b><%= "#{character.character_name} - #{character.character_heritage} #{character.character_class} #{character.character_level}" %></b>
            </div>
            <details class="dropdown mb-0" id={"character-dropdown-#{character.id}"}>
              <summary role="button" class="outline p-1">...</summary>
              <ul style="transform: translateX(-75px);" onclick={"document.getElementById('character-dropdown-#{character.id}').open = false"}>
                <li><a href={"/party-tracker/session/#{@session.id}/character/#{character.id}"}>Go to Character</a></li>
                <li><a href={"/party-tracker/session/#{@session.id}/character/#{character.id}"}>Edit Character</a></li>
                <li><a href="#" phx-click="toggle-hp-buttons" phx-value-id={character.id}>Toggle HP Buttons</a></li>
              </ul>
            </details>
          </header>
          <div class="flex justify-between"><p>AC: <%= character.character_ac |> Integer.to_string %></p> <p>CDC: <%= character.character_ac |> Integer.to_string %></p></div>
          <div class="character-img-tray mb-2">
            <img class="character_picture" src={character.character_picture}>
          </div>
            <.live_component 
              module={Components.Healthbar} 
              id={"#{character.id}-hp"} 
              current_hp={character.character_current_hp} 
              max_hp={character.character_max_hp} />   
        </article>
      <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"session_id" => id}, _session, socket) do
    DoodlexWeb.Endpoint.subscribe("session:#{id}")
    maybe_session = Session.get(id)
    case maybe_session do
      %Session{} = session ->
        characters = Character.get_by_session(id)
        Enum.each(characters, fn character ->
          DoodlexWeb.Endpoint.subscribe("character:#{character.id}")
        end)
        {:ok,
          socket
          |> assign(session: session, not_found: false )
          |> assign(characters: characters)
        }
      nil ->
        {:ok, assign(socket, not_found: true, session: nil)}
    end
  end

  def handle_info(%{event: "update-character", payload: payload} = attrs, socket) do
    payload_no_id = Map.delete(payload, :id)
    character_id = payload.id
    updates = Map.delete(payload, :id)
    new_characters = Enum.map(socket.assigns.characters, fn character ->
      if character.id == character_id do
        Map.merge(character, updates)
      else
        character
      end
    end)
    {:noreply, 
    socket
    |> assign(characters: new_characters)}
  end
  def handle_event(event, params, socket) do
    IO.puts "--- HANDLE_INFO_SESSION_LIVE"
    IO.inspect event
    IO.inspect params
    
    {:noreply, 
    socket}
  end
end
