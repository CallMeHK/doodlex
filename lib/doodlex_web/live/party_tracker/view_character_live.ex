defmodule DoodlexWeb.PartyTracker.ViewCharacterLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Character
  alias Doodlex.PartyTracker.Components

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section>
            <h2><%= @character[:character_name]%></h2>
         </section>
         <section>
          <.live_component module={Components.Healthbar} id="char_healthbar" content="big yeet" current_hp={@hp} max_hp={@max} />   
         </section>
      </main>
      <button phx-click="decrease">decrease</button>
    Current temperature: <%= if @not_found, do: "Cant find character!", else: "Found character " <> @character[:character_name] %>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    maybe_character = Character.get(String.to_integer(id))
    case maybe_character do
      %Character{} = character ->
        {:ok, assign(socket, character: Map.from_struct(character), not_found: false, hp: 60, max: 100 )}
      nil ->
        {:ok, assign(socket, not_found: true, character: nil)}
    end
  end

  def handle_event("decrease", _params, socket) do
    {:noreply, 
      socket
      |> assign(hp: socket.assigns.hp - 10)
    }
  end
end
