defmodule DoodlexWeb.PartyTrackerLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  use DoodlexWeb, :html
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Session

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section id="intro">
            <div class="md-section">
              <div id="recent-session" phx-update="ignore"></div>

              <script>
                const recentSession = localStorage.getItem("recentSession")

                if (recentSession) {
                  const { id, name } = JSON.parse(recentSession) || {}

                  if (id && name) {
                    document.querySelector('#recent-session').innerHTML = `
                    <article>
                      <h4>Recent Session</h4>
                      <p><a href="/party-tracker/session/${id}">${name}</a></p>
                    </article>
                      `
                  }
                }
              </script>
              <p><strong>party tracker</strong> is an interactive, real time application for tracking your fellow role playing gamers character status and metadata. Ask your DM for a link to your party's session, or enter your session's alias below.</p>
              
              <.form  for={@form} id="alias_form" phx-change="change_alias_form" phx-submit="submit_alias_form">
                <fieldset>
                  <label>
                    Session Alias
                    <.finput
                      placeholder=""
                      autocomplete="session_alias"
                      field={@form[:alias]}
                    />
                  </label>
                </fieldset>

                <%= if elem(@errors, 0) == :error do %>
                  <p style="color: red"><%= elem(@errors, 1) %></p>
                <% end %>
                <input
                  id="alias_form_submit"
                  type="submit"
                  value="Join Session"
                />
              </.form>

              <%= if @is_super do %>
                <h4>Quick links</h4>
                <p><a href="/party-tracker/create-character">Create a character</a></p>
                <p><a href="/party-tracker/session/create">Create a session</a></p>
                <p><a href="/party-tracker/join-session">Join a session</a></p>
                <p><a href="/party-tracker/session/all">All Sessions</a></p>
              <% end %>
            </div>
         </section>
      </main>
    """
  end


  defmodule AliasForm do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :alias, :string
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [:alias])
      |> validate_required([:alias])
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end


  def handle_event("change_alias_form", %{"alias_form" => alias_form} = params, socket) do
    form = %AliasForm{}
    |> AliasForm.changeset(alias_form)
    |> to_form(action: :validate)
    
    IO.inspect form

    {:noreply, 
      socket
      |> assign(form: form)
    }
  end

  def handle_event("submit_alias_form", %{"alias_form" => %{"alias" => alias}}, socket) do
    valid? = socket.assigns.form.source.valid?
    error_msg = "Could not fetch session, try again"

     if valid? do
       maybe_session = alias
       |> Session.get_by_alias()

       # prevent enumeration
       :timer.sleep(1500)

       case maybe_session do
         %Session{id: session_id} -> 
           {:noreply, redirect(socket, to: "/party-tracker/session/" <> session_id)}
         nil -> 
           {:noreply, 
           socket
           |> assign(:errors, {:error, "Could not fetch session, try again"})}
       end
     else
       {:noreply, 
       socket
       |> assign(:errors, {:error, "No alias provided"})
       }
     end
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
      |> assign(:errors, {:no_submit, ""})
      |> assign_form(AliasForm.changeset(%AliasForm{}))
    }
  end
end
