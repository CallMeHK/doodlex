defmodule DoodlexWeb.PartyTracker.CreateCharacterLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Character
  alias Doodlex.PartyTracker.Session

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section>
            <h2>Create a Character</h2>
         </section>
         <section id="intro">
            <div class="md-section">
              <.form  for={@form} id="character_form" phx-change="change_character_form" phx-submit="submit_character_form">
                <fieldset class='grid'>
                  <label>
                    Name
                    <.finput
                      placeholder="Grognak, Duga, Larry..."
                      field={@form[:character_name]}
                    />
                  </label>
                  <label>
                    Class
                    <.finput
                      placeholder="Bard, Barbarian..."
                      field={@form[:character_class]}
                    />
                  </label>
                </fieldset>

                <fieldset class='grid'>
                  <label>
                    Heritage
                    <.finput
                      placeholder="Human, Elf, Orc..."
                      field={@form[:character_heritage]}
                    />
                  </label>
                  <label>
                    Picture URL
                    <.finput
                      placeholder="Use a URL from mostly anywhere"
                      field={@form[:character_picture]}
                    />
                  </label>
                </fieldset>

                <fieldset class='grid'>
                  <label>
                    Level
                    <.finput
                      type="number"
                      field={@form[:character_level]}
                    />
                  </label>
                  <label>
                    Max HP
                    <.finput
                      type="number"
                      field={@form[:character_max_hp]}
                    />
                  </label>
                  <label>
                    Armor Class (AC)
                    <.finput
                      type="number"
                      field={@form[:character_ac]}
                    />
                  </label>
                </fieldset>

                <%= if elem(@errors, 0) == :error do %>
                  <p style="color: red"><%= elem(@errors, 1) %></p>
                <% end %>
                <input
                  id="character_form_submit"
                  type="submit"
                  value="Create Character"
                />
              </.form>
            </div>
         </section>
      </main>
    """
  end

  defmodule CharacterForm do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :character_name, :string
      field :character_class, :string
      field :character_heritage, :string
      field :character_picture, :string
      field :character_level, :integer
      field :character_max_hp, :integer
      field :character_ac, :integer
      # field :character_portrait, :string
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [
        :character_name, :character_class, :character_heritage, :character_picture, :character_level, :character_max_hp, :character_ac
      ])
      |> validate_required([
        :character_name, :character_class, :character_heritage, :character_picture, :character_level, :character_max_hp, :character_ac
      ])
    end

    defp ensure_int(int?) do
      if is_integer(int?), do: int?, else: String.to_integer(int?)
    end

    def convert_strings(form) do
      %{"character_ac" => character_ac, "character_max_hp" =>  character_max_hp, "character_level" => character_level} = form
      c_ac = ensure_int(character_ac)
      c_max_hp = ensure_int(character_max_hp)
      c_level = ensure_int(character_level)

      Map.merge(form, %{
        "character_ac" => c_ac, "character_max_hp" =>  c_max_hp, "character_level" => c_level
      })
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def mount(params, _session, socket) do
    maybe_id = Map.get(params, "session_id")

    case Session.get(maybe_id) do
      %Session{id: id} ->
        {:ok, 
          socket
          |> assign(:errors, {:no_submit, ""})
          |> assign(:session_id, id)
          |> assign_form(CharacterForm.changeset(%CharacterForm{}))
        }
      _ -> 
        {:noreply, redirect(socket, to: "/party-tracker")}
    end
  end

  def handle_event("change_character_form", %{"character_form" => character_form} = params, socket) do
    form = %CharacterForm{}
    |> CharacterForm.changeset(character_form)
    |> to_form(action: :validate)

    {:noreply, 
      socket
      |> assign(form: form)
    }
  end

  def handle_event("submit_character_form", %{"character_form" => character_form}, socket) do
    IO.inspect socket.assigns

    valid? = socket.assigns.form.source.valid?

    :timer.sleep(1000)
    if valid? do
      maybe_character = CharacterForm.convert_strings(character_form)
      |> Map.merge(%{"session_id" => socket.assigns.session_id})
      |> Character.create()
      |> IO.inspect

      case maybe_character do
        {:ok, %Character{id: character_id}} -> 
          IO.puts "character created successfully"
          {:noreply, redirect(socket, to: "/party-tracker/session/#{socket.assigns.session_id}/character/#{Integer.to_string(character_id)}")}
        {:error, _} -> 
          {:noreply, 
          socket
          |> assign(:errors, {:error, "Unable to create character at this time. Please try again."})}
      end

    else
      {:noreply, 
      socket
      |> assign(:errors, {:error, "Must fill out all fields."})
      }
    end
  end
end


# Character portrait dropdown that works if i want it later
#                <fieldset class='grid'>
#                  <details class="dropdown" id="portrait_dropdown">
#                    <summary><%= Map.get(@form[:character_portrait], :value) || "Select a Portrait" %></summary>
#                    <ul onclick="document.getElementById('portrait_dropdown').open = false">
#                      <li phx-click="dropdown" phx-value-class="Bard"><a href="#">Bard</a></li>
#                      <li phx-click="dropdown" phx-value-class="Barbarian"><a href="#">Barbarian</a></li>
#                      <li phx-click="dropdown" phx-value-class="Inventor"><a href="#">Inventor</a></li>
#                    </ul>
#                  </details>
#                </fieldset>
                


#  def handle_event("dropdown", %{"class" => class}, socket) do
#    form_data = socket.assigns.form.params
#
#    new_form = Map.merge(form_data, %{"character_portrait"})
#
#    form = %CharacterForm{}
#    |> CharacterForm.changeset(character_form)
#    |> to_form(action: :validate)
#
#    {:noreply, 
#      socket
#      |> assign(form: form)
#    }
#
#    {:noreply, socket}
#  end
