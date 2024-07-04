defmodule DoodlexWeb.PartyTracker.ViewCharacterLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Character
  alias Doodlex.PartyTracker.Components

  def render(assigns) do
    ~H"""
      <main class="container my-8">
        <style>
          @scope {
            :scope {
              .character_picture {
                width: 100%;
              }
              @media (max-width: 1281px) {
                .card_container {
                  grid-template-columns: none;
                }
              }
            }
          }
        </style>
         <section>
            <h2><%= @character[:character_name]%></h2>
         </section>
         <section>
          <div class="grid card_container">
            <article><img class="character_picture" src={@character[:character_picture]}></article>
            <article>
              <div>
                <.live_component 
                  module={Components.Healthbar} 
                  id="char_healthbar" 
                  content="big yeet" 
                  current_hp={@character[:character_current_hp]} 
                  max_hp={@character[:character_max_hp]} />   
              </div>
              <div class="grid">
                <p><strong><%= "Level #{@character[:character_level]} #{@character[:character_heritage]} #{@character[:character_class]}" %></strong></p>
                <p><strong><%= "AC #{Integer.to_string(@character[:character_ac])}" %></strong></p>
                <p><strong><%= "Class DC #{Integer.to_string(@character[:character_ac])}" %></strong></p>
              </div>
              <div class="grid mt-6 mb-6 dmg-btn">
                <button phx-click="update-hp" value="-1" style="background: #a60808;">1 Damage</button>
                <button phx-click="update-hp" value="-5" style="background: #a60808;">5 Damage</button>
                <button phx-click="update-hp" value="-10" style="background: #a60808;">10 Damage</button>
              </div>
              <div class="grid mt-6 mb-6">
                <button phx-click="update-hp" value="1">Heal 1</button>
                <button phx-click="update-hp" value="5">Heal 5</button>
                <button phx-click="update-hp" value="10">Heal 10</button>
              </div>
            </article>
          </div>
         </section>
      </main>
    <!-- Current temperature: <%= if @not_found, do: "Cant find character!", else: "Found character " <> @character[:character_name] %> -->
    """
  end

  def mount(%{"id" => id, "session_id" => maybe_session_id}, _session, socket) do
    DoodlexWeb.Endpoint.subscribe("character:#{id}")
    maybe_character = Character.get(String.to_integer(id)) |> IO.inspect
    case maybe_character do
      %Character{session_id: session_id} = character ->
        if session_id == maybe_session_id do
          {:ok, assign(socket, character: Map.from_struct(character), not_found: false )}
        else
          {:ok, redirect(socket, to: "/party-tracker")}
        end
      nil ->
        {:ok, assign(socket, not_found: true, character: nil)}
    end
  end

  def handle_event("update-hp", %{"value" => value_str} = params, socket) do
    IO.inspect params

    value = String.to_integer(value_str)
    character = socket.assigns.character
    {:ok, %{character_current_hp: character_current_hp}} = Character.update_hp(character.id, value)
    DoodlexWeb.Endpoint.broadcast_from(self(), "character:#{Integer.to_string(character.id)}", "update-character", %{character_current_hp: character_current_hp})
    {:noreply, 
      socket
      |> assign(character: Map.merge(socket.assigns.character, %{character_current_hp: character_current_hp}))
    }
  end

  def handle_info(%{event: "update-character", payload: payload}, socket) do
    IO.puts "--- HANDLE_INFO"
    IO.inspect payload
    {:noreply, 
    socket 
    |> assign(character: Map.merge(socket.assigns.character, payload))}
  end
end
