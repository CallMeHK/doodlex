defmodule DoodlexWeb.PartyTracker.AllSessionsLive do

  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import DoodlexWeb.CoreComponents
  alias Doodlex.PartyTracker.Session
  alias Doodlex.PartyTracker.Character

  def render(assigns) do
    ~H"""
      <main class="container my-8">
         <section>
            <h2>All Sessions</h2>
         </section>
         <section id="sessions">
          <table>
           <thead>
             <tr>
               <th scope="col">Name</th>
               <th scope="col">Description</th>
               <th scope="col">Link</th>
             </tr>
           </thead>
           <tbody>
             <%= for session <- @sessions do %>   
               <tr>
                 <th scope="row"><%= session.name %></th>
                 <td><%= session.description %></td>
                 <td><a href={"/party-tracker/session/#{session.id}"}><%= session.id %></a></td>
               </tr>
             <% end %>
           </tbody>
          </table>
         </section>
         <section>
            <h2>All Characters</h2>
         </section>
         <section id="characters">
          <table>
           <thead>
             <tr>
               <th scope="col">ID</th>
               <th scope="col">Name</th>
               <th scope="col">Session</th>
               <th scope="col">Link</th>
             </tr>
           </thead>
           <tbody>
             <%= for character <- @characters do %>   
               <tr>
                 <th scope="row"><%= character.character_name %></th>
                 <td><%= character.id %></td>
                 <td><%= character.session_id %></td>
                 <td><a href={"/party-tracker/session/#{character.session_id}/character/#{character.id}"}><%= "/party-tracker/session/#{character.session_id}/character/#{character.id}" %></a></td>
               </tr>
             <% end %>
           </tbody>
          </table>
         </section>
      </main>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(sessions: Session.all())
      |> assign(characters: Character.all())
    }
  end
end
