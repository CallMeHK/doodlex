defmodule DoodlexWeb.PartyTracker.CreateSessionLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Session

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section>
            <h2>Create a Session</h2>
         </section>
         <section id="intro">
            <div class="md-section">
              <.form  for={@form} id="session_form" phx-change="change_session_form" phx-submit="submit_session_form">
                <fieldset>
                  <label>
                    Session name
                    <.finput
                      placeholder="Outlaws of Alkenstar, Waterdeep, etc"
                      field={@form[:name]}
                    />
                  </label>
                  <label>
                    Session Description
                    <.finput
                      placeholder="A Tale Among Tales!"
                      field={@form[:description]}
                    />
                  </label>
                </fieldset>

                <%= if elem(@errors, 0) == :error do %>
                  <p style="color: red"><%= elem(@errors, 1) %></p>
                <% end %>
                <input
                  id="session_form_submit"
                  type="submit"
                  value="Create Session"
                />
              </.form>
            </div>
         </section>
      </main>
    """
  end

  defmodule SessionForm do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :name, :string
      field :description, :string
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [:name, :description])
      |> validate_required([:name, :description])
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(:errors, {:no_submit, ""})
      |> assign_form(SessionForm.changeset(%SessionForm{}))
    }
  end

  def handle_event("change_session_form", %{"session_form" => session_form} = params, socket) do
    form = %SessionForm{}
    |> SessionForm.changeset(session_form)
    |> to_form(action: :validate)

    {:noreply, 
      socket
      |> assign(form: form)
    }
  end

  def handle_event("submit_session_form", %{"session_form" => session_form}, socket) do
    valid? = socket.assigns.form.source.valid?

     if valid? do
       maybe_session = session_form
       |> Session.create()
       |> IO.inspect

       case maybe_session do
         {:ok, %Session{id: session_id}} -> 
           IO.puts "character created successfully"
           {:noreply, redirect(socket, to: "/party-tracker/session/" <> session_id)}
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
