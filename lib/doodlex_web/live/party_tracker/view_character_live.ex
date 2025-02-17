defmodule DoodlexWeb.PartyTracker.ViewCharacterLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Character
  alias Doodlex.PartyTracker.Components
  alias Phoenix.LiveView.JS
  use DoodlexWeb, :verified_routes

  def render(assigns) do
    ~H"""
      <div>
      <style>
        #view-char {
          .char-header {
            display: flex;
            justify-content: space-between;
          }
          .character_picture {
            width: 100%;
          }
          @media (max-width: 1281px) {
            .card_container {
              grid-template-columns: none;
            }
          }
        }
      </style>
      <main id="view-char" class="container my-8">
        <a href={"/party-tracker/session/#{@character.session_id}"}>Back to session</a>
         <section>
            <div class="char-header mb-4">
              <h2 class="mt-3"><%= @character[:character_name]%></h2>
              <details class="dropdown mb-0">
                <summary role="button" class="outline"><img src={~p"/images/wrench.svg"} width="32px" height="32px"></summary>
                <ul style="transform: translateX(-75px);">
                  <li><a href={"/party-tracker/session/#{@character.session_id}/character/edit/#{@character.id}"}>Edit Character</a></li>
                  <li><a href={"javascript:void(0)"} phx-click={JS.set_attribute({"open", "true"}, to: "#delete-character-modal")} phx-value-delete_modal="open">Delete Character</a></li>
                </ul>
              </details>
            </div>
         </section>
         <section>
          <div class="grid card_container">
            <article phx-click="tester">
              <img class="character_picture" src={@character[:character_picture]}>
            </article>
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
                <p><strong><%= "Class DC #{Integer.to_string(@character[:character_cdc])}" %></strong></p>
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
         <dialog id="delete-character-modal">
          <article>
            <header>
              <button aria-label="Close" rel="prev" phx-click={JS.remove_attribute("open", to: "#delete-character-modal")}></button>
              <p>
                <strong>Permanently Delete <%= @character[:character_name]%>?</strong>
              </p>
            </header>
            <p>
              Are you sure?
            </p>
            <div class="grid">
              <button style="background:red" phx-click="delete-character">Delete Character</button>
              <button  phx-click={JS.remove_attribute("open", to: "#delete-character-modal")}>Cancel</button>
            </div>
          </article>
        </dialog>
      </main>
      </div>
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

  def handle_event("delete-character", _params, socket) do
    character_id = socket.assigns.character.id
    session_id = socket.assigns.character.session_id

    case Character.delete(character_id) do
       {:ok, _} -> {:noreply, push_navigate(socket, to: "/party-tracker/session/#{session_id}")}
      _ -> {:noreply, socket}
    end
  end

  def handle_event("update-hp", %{"value" => value_str} = params, socket) do
    value = String.to_integer(value_str)
    character = socket.assigns.character
    {:ok, %{character_current_hp: character_current_hp, id: id}} = Character.update_hp(character.id, value)
    DoodlexWeb.Endpoint.broadcast_from(self(), "character:#{Integer.to_string(character.id)}", "update-character", %{character_current_hp: character_current_hp, id: id})
    {:noreply, 
      socket
      |> assign(character: Map.merge(socket.assigns.character, %{character_current_hp: character_current_hp}))
    }
  end

  def handle_info(%{event: "update-character", payload: payload}, socket) do
    payload_no_id = Map.delete(payload, :id)
    {:noreply, 
    socket 
    |> assign(character: Map.merge(socket.assigns.character, payload_no_id))}
  end

  def handle_event(event, params, socket) do
    IO.puts "-------------- FALLBACK EVENT"
    IO.inspect(event)
    IO.inspect(params)
    IO.inspect(socket.assigns)
    {:noreply, 
      socket
    }
  end
end
